Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0BNU07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:26:59 -0500
Received: from mx2.isti.cnr.it ([194.119.192.4]:4001 "EHLO mx2.isti.cnr.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0BNU05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:26:57 -0500
Date: Sun, 14 Feb 2010 21:25:45 +0100
From: Asdo <asdo@shiftmail.org>
Subject: Re: Linux mdadm superblock question.
In-reply-to: <4B7719C1.1060400@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
       Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <4B785C49.7010105@shiftmail.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
X-INSM-ip-source: 151.81.210.150 Auth Done
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
 <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
 <4B77044B.1020609@zytor.com>
 <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan>
 <4B7719C1.1060400@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 02/13/2010 12:07 PM, Justin Piszcz wrote:
>   
> 0.90 has a very bad problem, which is that it is hard to distinguish
> between a RAID partition at the end of volume and a full RAID device.
> This is because 0.90 doesn't actually tell you the start of the device.
>
> Then, of course, there are a lot of limitations on size, number of
> devices, and so on in 0.90.
>
> 	-hpa
>   
I don't understand...
In a system we have, the root filesystem on a raid-6 which is on second 
(and last) partitions of many disks.
It always assembled correctly, it never tried to assemble the whole device.
(on the first partition there is a raid1 with boot)
So what's the problem exactly with not marking the beginning?
