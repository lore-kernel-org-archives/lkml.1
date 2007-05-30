Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbXE3Ikt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbXE3Ikt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbXE3IkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:40:14 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54487 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbXE3IkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:40:12 -0400
Date: Wed, 30 May 2007 10:31:06 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Nitin Gupta <nitingupta910@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
In-Reply-To: <4cefeab80705292254k33079e90j52a32a813b12a887@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705301028190.11140@yvahk01.tjqt.qr>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> 
 <Pine.LNX.4.61.0705292236490.11140@yvahk01.tjqt.qr>
 <4cefeab80705292254k33079e90j52a32a813b12a887@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 30 2007 11:24, Nitin Gupta wrote:
>> 
>> It is the bytestream (ip) that is reinterpreted as uint16_t.
>> And I really doubt that the LZO author has a big-endian machine,
>> given the days of ubiquitous x86.
>
>> le16_to_cpu it is.
>
> But then why you think it should be
> le_16_cpu() -- how will this make any difference?

Like I said, we are reinterpreting the byte stream as a uint16_t
(= reading from bytestream to CPU). While writing out an uint16_t
as a bytestream is cpu_to_le16.

> For your ref (from big_endian.h):
> # define __cpu_to_le16(x) ((__force __le16)__swab16((x)))
> # define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))


	Jan
-- 
