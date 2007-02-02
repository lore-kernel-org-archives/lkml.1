Return-Path: <linux-kernel-owner+w=401wt.eu-S933218AbXBBLTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218AbXBBLTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 06:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933339AbXBBLTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 06:19:05 -0500
Received: from rzcomm12.rz.tu-bs.de ([134.169.9.59]:61115 "EHLO
	rzcomm12.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933218AbXBBLTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 06:19:04 -0500
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Feb 2007 06:19:03 EST
Message-ID: <45C31C19.5040200@l4x.org>
Date: Fri, 02 Feb 2007 12:10:17 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Thunderbird 2.0pre (Windows/20070130)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: lirc@bartelmus.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lirc: remove backwards compatibility macro obfuscation
 (Was: Free Linux Driver Development!)
References: <Pine.LNX.4.64.0702021038270.21422@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0702021038270.21422@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> On 02 Feb 2007 05:54:00 +0100, Christoph Bartelmus <lirc@bartelmus.de> wrote:
>> I just made clear that I don't have the time to do the merging of LIRC
>> drivers to the kernel myself. In fact a lot of work still needs to be
>> done before LIRC drivers are ready to be included into the kernel.
> 
> [snip]
> 
> On 02 Feb 2007 05:54:00 +0100, Christoph Bartelmus <lirc@bartelmus.de> wrote:
>> Any help welcome.
> 
> Here's a start. You really should run Lindent on the sources too.

Pekka, it would be better if you could sort out most of the
basic issues with lirc directly with the developers of lirc
and then prepare a complete patch series and post that to
lkml. Incrementally adding one driver after another. Posting
patches to non-existent sources to lkml is pointless. First
create a discussion base, please.

> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
> 
>  drivers/lirc_atiusb/lirc_atiusb.c           |  102 -----------------
>  drivers/lirc_bt829/lirc_bt829.c             |    9 -

You might want to fix the directory structure first and check
which drivers already exist in-tree.
Also, as Vincent noted, most drivers have to be converted
to use the input layer first.

Jan
