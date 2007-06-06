Return-Path: <linux-kernel-owner+w=401wt.eu-S936301AbXFFWN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936301AbXFFWN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935159AbXFFWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:13:49 -0400
Received: from lucidpixels.com ([75.144.35.66]:42925 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935349AbXFFWNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:13:47 -0400
Date: Wed, 6 Jun 2007 18:13:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706061505.11741.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706061813260.4961@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <Pine.LNX.4.64.0706061747180.3697@p34.internal.lan>
 <Pine.LNX.4.64.0706061803040.4671@p34.internal.lan> <200706061505.11741.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Jesse Barnes wrote:

> On Wednesday, June 6, 2007 3:03 pm Justin Piszcz wrote:
>> Mem:   8039620k total,  7936472k used,   103148k free,      708k
>> buffers Mem:   8039608k total,   969380k used,  7070228k free,
>> 1232k buffers
>>
>> I am curious, why does the patch != the mem=8832M?
>
> I'm not sure... can you post your e820 map from boot and the contents
> of /proc/mtrr?  Maybe my patch is trimming off a few too many pages, or
> maybe 8832M isn't quite right and actually ends up leaving you with a
> few uncached pages.
>
> Jesse
>

Unless you know of some other way I can capture the output, it only starts 
showing the dmesg from [50..] onward.

Justin.
