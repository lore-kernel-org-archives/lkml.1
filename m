Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZGKFvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZGKFvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 01:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZGKFvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 01:51:31 -0400
Received: from ambarella-ex.ambarella.net ([63.164.14.166]:2559 "EHLO
	ambarella-ex.ambarella.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbZGKFva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 01:51:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggZm9yLTIuNi4zMl0gc291bmQgZGFw?=
	=?utf-8?B?bTogZml4IGNoZWNraW5nIGZvciBleHRlcm5hbCB3aWQ=?=
	=?utf-8?B?Z2V0cyBidWc=?=
Date: Fri, 10 Jul 2009 22:51:25 -0700
Message-ID: <90B0CE4312136749B97EBEAF5764F87403CF756C@ambarella-ex.ambarella.net>
In-Reply-To: <20090710191925.GA5916@sirena.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH for-2.6.32] sound dapm: fix checking for external widgets bug
Thread-Index: AcoBk3A6WotSBTROT/SY6Ay74GpgXQAVwkRw
References: <90B0CE4312136749B97EBEAF5764F87403C8F77A@ambarella-ex.ambarella.net> <20090710191925.GA5916@sirena.org.uk>
From: "Rongrong Cao" <rrcao@ambarella.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
       <trivial@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6B5pnXx001341

Hi, Mark

I'm sorry for sending the unqualified patches two times.
It's my first time to submit patch into kernels, so I'm in lack of the submitting experiences.

I'll read the documents carefully, and I want to submit a codec(CS24L51) driver patch in recently
future. I hope everything will go with a swing at that time.

Thanks!

********************
Best regards!
Allen (Rongrong) Cao
Ambarella Shanghai Ltd.
Tel:Â Â  (86-21) 50942311
Fax:Â  (86-21) 50942321


-----é‚®ä»¶åŸä»¶-----
å‘ä»¶äºº: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
å‘é€æ—¶é—´: 2009å¹´7æœˆ11æ—¥ 3:19
æ”¶ä»¶äºº: Rongrong Cao
æŠ„é€: alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org; trivial@kernel.org
ä¸»é¢˜: Re: [PATCH for-2.6.32] sound dapm: fix checking for external widgets bug

On Tue, Jul 07, 2009 at 11:11:46PM -0700, Rongrong Cao wrote:
> From: Rongrong Cao rrcao@ambarella.com

> This patch is based on for-2.6.32
> In SOC DAPM layer of SOUND subsystem, when add signal route (in the function snd_soc_dapm_add_route() ), 
> the original code has wrong logic when dapm layer check each widget whether an external one.

This still doesn't apply.  It looks like your MUA is corrupting the
patch - it's MIME encoded everything and replaced all the tabs with
spaces which is causing all the patch application programs I have to get
confused.  Documentation/email-clients.txt has some suggestions on how
to configure various MUAs to send patches cleanly.  Personally I always
use git send-email.  You probably also want to have a look at the
instructions in Documentation/SubmittingPatches with regard to the
formatting of your patch - the main thing being that the Signed-off-by
should go before the patch content.

In any case, I've manually applied the patch so no need to resubmit it.

I also notice that you've CCed trivial@kernel.org.  Please don't do that
except for things that can't possibly cause bugs - a change like this
doesn't really qualify since while the code clearly looks buggy it's
always possible that the code is just obscure.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
