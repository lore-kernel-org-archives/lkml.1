Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYCQWzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYCQWzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYCQWzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:55:06 -0400
Received: from namei.org ([69.55.235.186]:48579 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753286AbYCQWzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:55:04 -0400
Date: Tue, 18 Mar 2008 09:51:10 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Miklos Szeredi <miklos@szeredi.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: Re: [patch 00/11] mount ownership and unprivileged mount syscall
 (v9)
In-Reply-To: <20080317200053.447640802@szeredi.hu>
Message-ID: <Xine.LNX.4.64.0803180947230.10104@us.intercode.com.au>
References: <20080317200053.447640802@szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something to consider down the track would be how to possibly allow this 
with SELinux, which only knows about normal mounts.

We might need a user_mount hook which is called once the core kernel code 
determines that it is a a valid unprivileged mount (although the sb_mount 
hook will already have been called, IIUC).


- James
-- 
James Morris
<jmorris@namei.org>
