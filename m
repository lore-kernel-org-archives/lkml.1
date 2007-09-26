Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbXIZNmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbXIZNmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbXIZNmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:42:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47843 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbXIZNmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:42:38 -0400
Date: Wed, 26 Sep 2007 14:42:23 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miloslav Semler <majkls@prepere.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, David Newall <david@davidnewall.com>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
Message-ID: <20070926134223.GO8181@ftp.linux.org.uk>
References: <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com> <46FA341A.80706@davidnewall.com> <6BA6E9EE-B67B-4334-AC83-9B8E30527832@mac.com> <46FA5A85.20407@prepere.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FA5A85.20407@prepere.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 03:11:33PM +0200, Miloslav Semler wrote:
> >As for the nested-chroot() bit, the root user inside of a chroot is 
> >always allowed to chroot().  This is necessary for test-suites for 
> >various distro installers, chroot once to enter the installer playpen, 
> >installer chroots again to configure the test-installed-system.  Once 
> >you allow a second chroot, you're back at the "can't reliably and 
> >efficiently track directory sub-tree members" problem.
> >
> >So if you think it can and should be fixed, then PROVIDE THE CODE.
> Miloslav Semler

man openat

This is really pointless, anyway - any code that expects chroot to be
root-proof is terminally broken.
