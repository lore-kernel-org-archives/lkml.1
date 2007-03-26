Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbXCZG42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbXCZG42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 02:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbXCZG42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 02:56:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56331 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933632AbXCZG41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 02:56:27 -0400
Date: Mon, 26 Mar 2007 08:56:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nicolas Boichat <nicolas@boichat.ch>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@lists.sourceforge.net,
       tiwai@suse.de
Subject: Re: [BUG] Patch "CPU hotplug: call check_tsc_sync_source() with irqs off" breaks some drivers
Message-ID: <20070326065604.GA19402@elte.hu>
References: <4606CA92.1000405@boichat.ch> <46074CD2.8000002@boichat.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46074CD2.8000002@boichat.ch>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nicolas Boichat <nicolas@boichat.ch> wrote:

> > I found out which commit seems to cause these bugs:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d04f41e35343f1d788551fd3f753f51794f4afcf
> > 
> > The latest GIT without this commit works fine, but doesn't with it.
> 
> Sorry about blaming this commit. The problems happen randomly (about 1 
> reboot over 2 is ok, at least with 2.6.21-rc4). I'll run more tests 
> and post the results later.

is this the 32-bit kernel? If yes then does commit 
4edc5db83f574dfcc8be35b7b96760ded543b360 (included in -rc5) fix it?

	Ingo
