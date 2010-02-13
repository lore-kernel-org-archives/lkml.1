Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab0BMV37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 16:29:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50118 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758114Ab0BMV3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 16:29:51 -0500
Message-ID: <4B7719C1.1060400@zytor.com>
Date: Sat, 13 Feb 2010 13:29:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 12:07 PM, Justin Piszcz wrote:
> 
> My original question was does the newer superblock do anything special
> or offer new features *BESIDES* the quicker resync?
> 

0.90 has a very bad problem, which is that it is hard to distinguish
between a RAID partition at the end of volume and a full RAID device.
This is because 0.90 doesn't actually tell you the start of the device.

Then, of course, there are a lot of limitations on size, number of
devices, and so on in 0.90.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

