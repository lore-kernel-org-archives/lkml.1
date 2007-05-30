Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbXE3N47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbXE3N47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbXE3N4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:56:52 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:55318 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbXE3N4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:56:51 -0400
Date: Wed, 30 May 2007 15:56:35 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Daniel Hazelton <dhazelton@enter.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Message-ID: <20070530135635.GA21827@linuxtv.org>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com> <200705281049.48679.dhazelton@enter.net> <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com> <20070528154346.GO3899@stusta.de> <4cefeab80705280903t6b2bb687g4eb1d9de2717f6ec@mail.gmail.com> <20070528171115.GQ3899@stusta.de> <Pine.LNX.4.61.0705292307320.11140@yvahk01.tjqt.qr> <20070529212625.GS3899@stusta.de> <4cefeab80705292231g4c166cd8xd920f2721cbb9c0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cefeab80705292231g4c166cd8xd920f2721cbb9c0e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 84.190.134.37
Subject: Re: [RFC] LZO de/compression support - take 6
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007, Nitin Gupta wrote:
> 
> Again, all the original code has been retained _as-is_. Whatever was
> changed, has been mentioned in that detailed changelog that I post
> along with patch.

Just a general remark (I haven't been following this thread closely):

IMHO it would be _much_ better to merge the original code and
your changes as seperate patches. Then someone who
wants to review it later doesn't have to jump through all
the hoops of finding the original code himself to diff it
and see your changes.

Additionally, you should also split stylistic/cleanup
changes like "Reformatted the code to match general kernel style"
from functional changes like "use cpu_to_le16()".

Ideally each of the changes you mention in your
"Changelog vs. original LZO" should be a seperate
patch, this would make review much easier.


Regards,
Johannes
