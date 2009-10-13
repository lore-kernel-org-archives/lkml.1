Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbZJMLfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbZJMLfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZJMLfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:35:22 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58694 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759206AbZJMLfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:35:20 -0400
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #16 01/25] LSM: Add security_path_chmod() andsecurity_path_chown().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp>
	<20091004125327.105675949@I-love.SAKURA.ne.jp>
	<4ACE1CFE.3020507@canonical.com>
	<alpine.LRH.2.00.0910121203090.19066@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0910121203090.19066@tundra.namei.org>
Message-Id: <200910132034.DAE39014.OVLFFOMHJQFOSt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 13 Oct 2009 20:34:42 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Thu, 8 Oct 2009, John Johansen wrote:
> 
> > Tetsuo Handa wrote:
> > > This patch allows pathname based LSM modules to check chmod()/chown()
> > > operations. Since notify_change() does not receive "struct vfsmount *",
> > > we add security_path_chmod() and security_path_chown() to the caller of
> > > notify_change().
> > >
> > > These hooks are used by TOMOYO.
> > 
> > This hooks would be useful for AppArmor as well.
> 
> 
> I've applied the first three patches to 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> 
Thank you.

> It would be good to see some more evidence of review for the remaining 
> patches.
Yes. I'm ready to submit first three patches.
