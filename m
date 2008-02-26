Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbYBZJ31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbYBZJ31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759918AbYBZJ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:29:19 -0500
Received: from namei.org ([69.55.235.186]:35053 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758646AbYBZJ3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:29:18 -0500
Date: Tue, 26 Feb 2008 20:28:43 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Alexey Dobriyan <adobriyan@sw.ru>
cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, eparis@parisplace.org,
       casey@schaufler-ca.com
Subject: Re: SMACK or SELinux, but not both
In-Reply-To: <20080226090953.GA7469@localhost.sw.ru>
Message-ID: <Xine.LNX.4.64.0802262020001.527@us.intercode.com.au>
References: <20080226090953.GA7469@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Alexey Dobriyan wrote:

> If SELinux is registered before SMACK, SMACK panics after
> register_security() call.
> 
> If SMACK is registered before SELinux, SELinux panics after
> register_security() call.
> 
> Consequently allmodconfig kernel doesn't boot. It would be nice if
> some Kconfig magic to exclude each other will be in place.

People want to be able to select the security model at boot time, so the 
option to build both LSMs is required.

You can stop SELinux from attempting to register as an LSM via selinux=0, 
which should allow you to boot with just Smack enabled.


- James
-- 
James Morris
<jmorris@namei.org>
