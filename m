Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbXE2V0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbXE2V0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbXE2V0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:26:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:48538 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750815AbXE2V03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:26:29 -0400
Date: Tue, 29 May 2007 23:26:25 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Nitin Gupta <nitingupta910@gmail.com>,
       Daniel Hazelton <dhazelton@enter.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Message-ID: <20070529212625.GS3899@stusta.de>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com> <200705281049.48679.dhazelton@enter.net> <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com> <20070528154346.GO3899@stusta.de> <4cefeab80705280903t6b2bb687g4eb1d9de2717f6ec@mail.gmail.com> <20070528171115.GQ3899@stusta.de> <Pine.LNX.4.61.0705292307320.11140@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705292307320.11140@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 11:10:05PM +0200, Jan Engelhardt wrote:
> 
> On May 28 2007 19:11, Adrian Bunk wrote:
> >
> >I have not seen any explanations:
> >- Why did the upstream author write the code that way?
> 
> I guess it's along the lines of
> - portability
> 
> (note how this contradicts itself). Really. I have yet to
> figure out why everyone invents their own xxx32_t types,
> like e.g. glib. well, integer types, one might understand, but when it
> comes to gchar or gpointer, that's just plain microsoft-style
> (think LPCSTR and LPCVOID...)

You completely miss the point of my question.

It's about the performance improvements of the modified code that were 
mentioned.

What you are talking about shouldn't have any effect on the generated 
code.

> 	Jan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

