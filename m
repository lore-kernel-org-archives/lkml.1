Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYGEXZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYGEXZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbYGEXYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:24:54 -0400
Received: from lucidpixels.com ([75.144.35.66]:47579 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbYGEXYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:24:53 -0400
Date: Sat, 5 Jul 2008 19:24:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <48700228.7060904@shaw.ca>
Message-ID: <alpine.DEB.1.10.0807051923380.23222@p34.internal.lan>
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no> <486FBFAB.5050303@shaw.ca> <alpine.DEB.1.10.0807051527210.8002@p34.internal.lan> <48700228.7060904@shaw.ca>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Jul 2008, Robert Hancock wrote:

> Justin Piszcz wrote:
>>> Can you post your dmesg from bootup with the controller/drive detection?
>
> So you've got 6 drives in the machine. Intel chipsets normally seem pretty 
> robust with AHCI.
>
> Are you certain that your machine has enough power to run all those drives 
> properly? We've seen in a number of cases that power fluctuations or noise 
> can cause these kinds of errors.

I have a 650watt PSU (nice antec one) and the power draw of the box is 
~148watts w/ veliciraptors, ~250 when fully load all 4 cores + all 12 
disks writing.  I have turned off the irqbalance daemon and I am going to 
see if the problem re-occurs.

Justin.
