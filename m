Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYAETrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYAETrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbYAETr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:47:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbYAETr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:47:26 -0500
Message-ID: <477FDEC8.3020605@zytor.com>
Date: Sat, 05 Jan 2008 11:47:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matt Domsch <Matt_Domsch@dell.com>
CC: Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Querying the bios from booted linux kernel?
References: <200801041913.54030.gene.heskett@gmail.com> <20080105041828.GB6011@auslistsprd01.us.dell.com>
In-Reply-To: <20080105041828.GB6011@auslistsprd01.us.dell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Domsch wrote:
> 
> parted and fdisk both write into the MBR signature space, so your
> disks should have unique MBR values in them.
> 

parted did so incorrectly, and had less than 20 bits of randomness.

fdisk only does so as of a very recent version (I put that in after I 
noticed a whole bunch of disks I had had zero identifiers.)

sfdisk doesn't at all, last I checked.

None check for collisions.

> I've given up trusting any BIOS to get EDD 3.0 device paths right,
> there are just too many broken implementations out there, and
> seemingly no real desire on the part of the component vendors to fix
> it.  MBR signatures work pretty well - Dell uses this method for every
> one of our factory installed Linux systems we ship, so I _know_ it works.

At least with a known distribution.  But yes, it really seems to be the 
most reliable method.

	-hpa


