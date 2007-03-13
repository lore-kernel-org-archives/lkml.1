Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbXCMMoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbXCMMoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXCMMoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:44:46 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:34848 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbXCMMop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:44:45 -0400
Date: Tue, 13 Mar 2007 12:42:48 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [SOUND] hda_intel: build fix
Message-ID: <20070313124248.GA25963@linux-mips.org>
References: <20070310190513.GA24435@linux-mips.org> <s5h8xe2soxt.wl%tiwai@suse.de> <20070312135351.GA11974@linux-mips.org> <s5hzm6ijzep.wl%tiwai@suse.de> <20070312154647.GC11974@linux-mips.org> <s5hodmyju1w.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hodmyju1w.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, that's a nasty part of C const.  It should be like
> 	const struct snd_ice1712_card_info *c;
> but for pointer-of-pointer, something like
> 	struct snd_ice1712_card_info * const *tbl;

Well, that works.

Andrew, I'm going to post an updated patch in separate email.

  Ralf
