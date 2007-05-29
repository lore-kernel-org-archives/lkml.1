Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbXE2VWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbXE2VWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXE2VVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:21:55 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:44674 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbXE2VVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:21:54 -0400
Date: Tue, 29 May 2007 23:10:05 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Adrian Bunk <bunk@stusta.de>
cc: Nitin Gupta <nitingupta910@gmail.com>,
       Daniel Hazelton <dhazelton@enter.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
In-Reply-To: <20070528171115.GQ3899@stusta.de>
Message-ID: <Pine.LNX.4.61.0705292307320.11140@yvahk01.tjqt.qr>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
 <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com>
 <200705281049.48679.dhazelton@enter.net> <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com>
 <20070528154346.GO3899@stusta.de> <4cefeab80705280903t6b2bb687g4eb1d9de2717f6ec@mail.gmail.com>
 <20070528171115.GQ3899@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 28 2007 19:11, Adrian Bunk wrote:
>
>I have not seen any explanations:
>- Why did the upstream author write the code that way?

I guess it's along the lines of
- portability

(note how this contradicts itself). Really. I have yet to
figure out why everyone invents their own xxx32_t types,
like e.g. glib. well, integer types, one might understand, but when it
comes to gchar or gpointer, that's just plain microsoft-style
(think LPCSTR and LPCVOID...)


	Jan
-- 
