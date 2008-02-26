Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbYBZMlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbYBZMlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbYBZMkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:40:35 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:43879 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbYBZMkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:40:24 -0500
Subject: Re: SMACK or SELinux, but not both
From: Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       eparis@parisplace.org, casey@schaufler-ca.com
In-Reply-To: <Xine.LNX.4.64.0802262020001.527@us.intercode.com.au>
References: <20080226090953.GA7469@localhost.sw.ru>
	 <Xine.LNX.4.64.0802262020001.527@us.intercode.com.au>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 26 Feb 2008 07:39:36 -0500
Message-Id: <1204029576.2804.260.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-26 at 20:28 +1100, James Morris wrote:
> On Tue, 26 Feb 2008, Alexey Dobriyan wrote:
> 
> > If SELinux is registered before SMACK, SMACK panics after
> > register_security() call.
> > 
> > If SMACK is registered before SELinux, SELinux panics after
> > register_security() call.
> > 
> > Consequently allmodconfig kernel doesn't boot. It would be nice if
> > some Kconfig magic to exclude each other will be in place.
> 
> People want to be able to select the security model at boot time, so the 
> option to build both LSMs is required.
> 
> You can stop SELinux from attempting to register as an LSM via selinux=0, 
> which should allow you to boot with just Smack enabled.

Ideally, one could just boot with security=<module> to select the
desired primary security module.  security=smack, security=selinux, or
security=capability.

Having to specify selinux=0 smack=0 foo=0 just to get bar wouldn't be
pretty.  Not that anyone would want to do that, of course...

-- 
Stephen Smalley
National Security Agency

