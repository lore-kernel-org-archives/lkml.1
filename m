Return-Path: <linux-kernel-owner+w=401wt.eu-S936497AbXFFWeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936497AbXFFWeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936479AbXFFWbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:31:13 -0400
Received: from lucidpixels.com ([75.144.35.66]:50958 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936471AbXFFWbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:31:11 -0400
Date: Wed, 6 Jun 2007 18:31:10 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706061528.44070.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706061830230.5415@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <200706061524.52628.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061826260.5415@p34.internal.lan>
 <200706061528.44070.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Jesse Barnes wrote:

> On Wednesday, June 6, 2007 3:26 pm Justin Piszcz wrote:
>> Nope, I booted with only netconsole= options.  I have a lot of HW in
>> the box and I guess the buffer is too small.  Not sure where to
>> change it in the kernel.  Looking..
>
> It's called "kernel log buffer size" and it's in "General setup".
>
> Jesse
>

I was reviewing some OLD mailing list archives then!

--------------

Per: http://www.edlug.ed.ac.uk/archive/Aug2003/msg00270.html

The kernel has a cyclic buffer of length LOG_BUF_LEN (4096, since 1.3.54:
8192, since 2.1.113: 16384; in
        recent kernels the size can be set at compile time) in which 
messages
given as argument  to  the  kernel
        function printk() are stored (regardless of their loglevel).

So it doesn't look like you can without recompiling...

Bruce

--------------

Getting you the E820 memory map in a few moments.


Changed from 15 -> 16.

   | |    (16) Kernel log buffer size (16 => 64KB, 17 => 128KB)


Justin.
