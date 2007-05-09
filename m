Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbXEINWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbXEINWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbXEINWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:22:12 -0400
Received: from lucidpixels.com ([75.144.35.66]:60230 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750AbXEINWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:22:10 -0400
Date: Wed, 9 May 2007 09:22:08 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: axboe@suse.de
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Alan Piszcz <ap@solarrain.com>
Subject: Chaining sg lists for big I/O commands: Question
Message-ID: <Pine.LNX.4.64.0705090918390.12857@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://kerneltrap.org/node/8176

I am a mdadm/disk/hard drive fanatic, I was curious:

> On i386, we can at most fit 256 scatterlist elements into a page,
> and on x86-64 we are stuck with 128. So that puts us somewhere
> between 512kb and 1024kb for a single IO.

How come 32bit is 256 and 64 is only 128?
I am sure it is something very fundamental/simple but I was curious, I 
would think x86_64 would fit/support more scatterlists in a page.

Also, when this patch is implemented for x86_64 and if merged into 
mainline, what does this mean for performance?

I have an mdadm raid5 of 10 raptors and get 434MB/s write and 622MB/s 
read, would I see an increase in performance with this patch?

Justin.

