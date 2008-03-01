Return-Path: <linux-kernel-owner+w=401wt.eu-S1761152AbYCAVMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761152AbYCAVMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 16:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbYCAVMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 16:12:36 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41594 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYCAVMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 16:12:35 -0500
Date: Sat, 1 Mar 2008 23:11:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [RFC PATCH -mm] LSM: Add lsm= boot parameter
Message-ID: <20080301211108.GF25835@cs181133002.pp.htv.fi>
References: <20080301190718.GA16307@ubuntu> <804479.65789.qm@web36610.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <804479.65789.qm@web36610.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 12:28:43PM -0800, Casey Schaufler wrote:
> 
> --- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:
> 
> > Hi everybody,
> > 
> > This is a first try of adding lsm= boot parameter. 
> > 
> > Current situation is:
> > 1- Ignore wrong input, with a small warning to users.
> > 2- If user didn't specify a specific module, none will be loaded
> 
> I'm not fond of this behavior for the case where only one LSM
> has been built in. Fedora, for example, ought to boot SELinux
> without specifing lsm=SELinux, and all the rest should boot
> whatever they are built with. In the case where a kernel is
> built with conflicting LSMs (today SELinux and Smack) I see
> this as a useful way to decide which to use until you get
> your kernel rebuilt sanely, so it appears to be worth having.
>...

Remarks:

Your comment would be covered if the default for this boot parameter (if 
not explicitely set through the boot loader would not be "disabled" but 
set through kconfig (based on the selected LSMs).

We should really get this resolved for 2.6.25.

security= suggestion is IMHO more intuitive than lsm=

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

