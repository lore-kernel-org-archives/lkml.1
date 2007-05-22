Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbXEVTqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbXEVTqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759998AbXEVTqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:46:13 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39878 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935400AbXEVTqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:46:11 -0400
Date: Tue, 22 May 2007 21:44:32 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Nitin Gupta <nitingupta910@gmail.com>
cc: Andrey Panin <pazke@donpac.ru>, linux-kernel@vger.kernel.org,
       Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO1X de/compression support
In-Reply-To: <4cefeab80705220208w2200b2f1x1d7a8c7e0c01dfb9@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705222143070.4452@yvahk01.tjqt.qr>
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com> 
 <20070518111107.GA27003@pazke.donpac.ru> <4cefeab80705220208w2200b2f1x1d7a8c7e0c01dfb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22 2007 14:38, Nitin Gupta wrote:
> On 5/18/07, Andrey Panin <pazke@donpac.ru> wrote:
>> On 138, 05 18, 2007 at 03:28:31PM +0530, Nitin Gupta wrote:
>> > +     register const unsigned char *ip;
>> 
>> register keyword is meaningless for today's compiler.
>
> But can we assume that gcc is being used? What if we use compiler for
> which it does matter (can't give example for this...)?

How dumb must a compiler be? Although I cannot give an example either,
the register keyword MAY 'clog up' a register, making it harder for
cc to optimally use the whole register set. Imagine we had even less
regs than the x86(_32) already does.


	Jan
-- 
