Return-Path: <linux-kernel-owner+w=401wt.eu-S2993462AbXEBQUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993462AbXEBQUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993463AbXEBQUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:20:00 -0400
Received: from lucidpixels.com ([75.144.35.66]:37066 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993462AbXEBQT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:19:59 -0400
Date: Wed, 2 May 2007 12:19:14 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: "Williams, Dan J" <dan.j.williams@intel.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, neilb@suse.de,
       akpm@linux-foundation.org,
       "Leech, Christopher" <christopher.leech@intel.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: RE: [PATCH 00/16] raid acceleration and asynchronous offload api
 for 2.6.22
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201CA8E4D@azsmsx413.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0705021218380.25382@p34.internal.lan>
References: <0C7297FA1D2D244A9C7F6959C0BF1E5201CA8E4D@azsmsx413.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 May 2007, Williams, Dan J wrote:

>> From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
>> I have not been following this closely, must you have an
>> CONFIG_INTEL_IOP_ADMA piece of hardware and/or chipset to use this
>> feature or can regular desktop users take hold of it as well?
>>
> Currently this feature is available on the iop series of processors,
> e.g. http://www.intel.com/design/iio/iop348.htm
>
> And there is a driver in the works to support the 440spe platform
> (http://marc.info/?l=linux-raid&m=117400143317440&w=2)
>
> Desktops currently take advantage of architecture specific SIMD
> instructions to accelerate xor calculations.
>
>> Justin.
>
> Dan
>

Ahh-- these are the family of chips in the Areca controllers (or close to 
them)-- so md/software raid will utilize the HW functions of the chip? 
If so, that is pretty slick :)

Justin.
