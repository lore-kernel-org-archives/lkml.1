Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbXJMICq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbXJMICq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 04:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXJMIC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 04:02:29 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:52330 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbXJMIC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 04:02:28 -0400
To: penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to find slab\'s usage?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710120701.l9C71Jx6038998@www262.sakura.ne.jp>
	<84144f020710130043v4f8e4cfbm178c88478d4b053d@mail.gmail.com>
In-Reply-To: <84144f020710130043v4f8e4cfbm178c88478d4b053d@mail.gmail.com>
Message-Id: <200710131702.FHD09857.VSQOLFtFOJHMFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 13 Oct 2007 17:02:25 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Pekka Enberg wrote:
> > I saw /proc/meminfo and it seems to me that slab is leaking memory.
> > But /usr/bin/slabtop claims /proc/slabinfo is missing.
> 
> Do you have CONFIG_SLUB enabled? Try looking into /sys/slab/.

Yes. There is /sys/slab/ .
But are there any tools for browsing like /usr/bin/slabtop ?
Is
  cd /sys/slab/; for i in *; do echo -n $i " "; cat $i/slabs; done
the only way currently available?

Thank you.

