Return-Path: <linux-kernel-owner+w=401wt.eu-S1031511AbXDZW7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031511AbXDZW7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031514AbXDZW7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:59:11 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:56774 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1031511AbXDZW7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:59:09 -0400
Date: Thu, 26 Apr 2007 15:24:13 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Pavel Machek <pavel@ucw.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <20070426224256.GB21926@elf.ucw.cz>
Message-ID: <Pine.LNX.4.63.0704261520350.9674@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> 
 <1177573348.5025.224.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
 <20070426224256.GB21926@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Pavel Machek wrote:

> This is basically the loop above, made complex by the fact that we do
> not want to have separate partition for snapshot; we just want to
> reuse free space in swap partition.

with the size of drives today is it really that bad to require a seperate 
partition for this?

I also don't like the idea of storing this in the swap partition for a couple of 
reasons.

1. on many modern linux systems the swap partition is not large enough.

for example, on my boxes with 16G or ram I only allocate 2G of swap space

2. it's too easy for other things to stomp on your swap partition.

   for example: booting from a live CD that finds and uses swap partitions

if you are needing space for your freeze, allocate it in an unabigous way, not 
by re-useing an existing partition.

David Lang


