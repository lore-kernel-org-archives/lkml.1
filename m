Return-Path: <linux-kernel-owner+w=401wt.eu-S937865AbYCSVgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937865AbYCSVgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763590AbYCSUHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:07:24 -0400
Received: from namei.org ([69.55.235.186]:53873 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763582AbYCSUHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:07:21 -0400
Date: Wed, 19 Mar 2008 10:04:16 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Miklos Szeredi <miklos@szeredi.hu>
cc: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, eparis@redhat.com,
       linux-security-module@vger.kernel.org
Subject: Re: [patch 00/11] mount ownership and unprivileged mount syscall
 (v9)
In-Reply-To: <E1Jba3y-0005eS-LX@pomaz-ex.szeredi.hu>
Message-ID: <Xine.LNX.4.64.0803191003480.14598@us.intercode.com.au>
References: <20080317200053.447640802@szeredi.hu>
 <Xine.LNX.4.64.0803180947230.10104@us.intercode.com.au>
 <E1Jba3y-0005eS-LX@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008, Miklos Szeredi wrote:

> > We might need a user_mount hook which is called once the core kernel code 
> > determines that it is a a valid unprivileged mount (although the sb_mount 
> > hook will already have been called, IIUC).
> 
> Does the order matter between core code's and the security module's
> permission checks?

Yes, the model is DAC before MAC.

>  If it does, the cleanest would be to just move the
> core checks before the sb_mount hook, no?

Correct.

-- 
James Morris
<jmorris@namei.org>
