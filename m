Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbXE3OY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbXE3OY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbXE3OYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:24:48 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:17614 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbXE3OYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xa3I7bcCZYtYsvVB3E8OhWMGFCtLi/9fS3BZAMPZ5dFKPbFDo0llFItBhdYd9fFltzPFFk0erQOoLYhN5549OI5W8/ViTmh6guYDnarE8Joqb00SFHmCUmBnSI5qgChMhaXdXIplOkbRk1Px83AvfnLAR9g5+akQVOtF4ozp+YM=
Message-ID: <a781481a0705300724k533029cei97033425f12b5b37@mail.gmail.com>
Date: Wed, 30 May 2007 19:54:43 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Johannes Stezenbach" <js@linuxtv.org>
Subject: Re: [RFC] LZO de/compression support - take 6
Cc: "Nitin Gupta" <nitingupta910@gmail.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Bret Towe" <magnade@gmail.com>
In-Reply-To: <20070530135635.GA21827@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <200705281049.48679.dhazelton@enter.net>
	 <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com>
	 <20070528154346.GO3899@stusta.de>
	 <4cefeab80705280903t6b2bb687g4eb1d9de2717f6ec@mail.gmail.com>
	 <20070528171115.GQ3899@stusta.de>
	 <Pine.LNX.4.61.0705292307320.11140@yvahk01.tjqt.qr>
	 <20070529212625.GS3899@stusta.de>
	 <4cefeab80705292231g4c166cd8xd920f2721cbb9c0e@mail.gmail.com>
	 <20070530135635.GA21827@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Johannes Stezenbach <js@linuxtv.org> wrote:
> On Wed, May 30, 2007, Nitin Gupta wrote:
> >
> > Again, all the original code has been retained _as-is_. Whatever was
> > changed, has been mentioned in that detailed changelog that I post
> > along with patch.
>
> Just a general remark (I haven't been following this thread closely):
>
> IMHO it would be _much_ better to merge the original code and
> your changes as seperate patches. Then someone who
> wants to review it later doesn't have to jump through all
> the hoops of finding the original code himself to diff it
> and see your changes.
>
> Additionally, you should also split stylistic/cleanup
> changes like "Reformatted the code to match general kernel style"
> from functional changes like "use cpu_to_le16()".
>
> Ideally each of the changes you mention in your
> "Changelog vs. original LZO" should be a seperate
> patch, this would make review much easier.

I violently agree with this method of going forward.
