Return-Path: <linux-kernel-owner+w=401wt.eu-S933670AbZAPPb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbZAPPb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZAPPbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:31:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57859 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZAPPbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:31:43 -0500
Date: Fri, 16 Jan 2009 16:33:46 +0100
From: Pavel Machek <pavel@suse.cz>
To: Valdis.Kletnieks@vt.edu
Cc: Eric Sandeen <sandeen@redhat.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Takashi Sato <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
Message-ID: <20090116153345.GC2022@elf.ucw.cz>
References: <496EB639.6090800@redhat.com> <20090116084828.GB4795@atrey.karlin.mff.cuni.cz> <16406.1232119029@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16406.1232119029@turing-police.cc.vt.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-16 10:17:09, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 16 Jan 2009 09:48:28 +0100, Pavel Machek said:
> 
> > Emergency Sync should not do this. Invent another key.
> > 
> > ...because otherwise, if you hit emergency sync but the system is
> > still alive and relies on filesystem freezing, bad stuff will happen.
> 
> Under what conditions would a system be alive and relying on freezing,
> *and* an emergency thaw would be worse than whatever reason you're doing
> an emergency sync?

I sometimes hit emergency sync on perfectly healthy system... like
before "insmod shiny-new-guaranteed-to-work-module"... I believe
sysrq-s should not have sideffects.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
