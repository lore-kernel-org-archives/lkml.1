Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYHMGBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYHMGBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 02:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYHMGBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 02:01:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55355 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYHMGBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 02:01:23 -0400
Message-ID: <48A278AE.1070800@zytor.com>
Date: Tue, 12 Aug 2008 23:01:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Adams <cmadams@hiwaay.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: AGP aperture beyond 4GB not valid?
References: <20080813013255.GD633804@hiwaay.net>
In-Reply-To: <20080813013255.GD633804@hiwaay.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Adams wrote:
> 
> Checking aperture...
> Node 0: aperture @ 1006000000 size 32 MB
> Aperture beyond 4GB. Ignoring.
> No AGP bridge found
> Your BIOS doesn't leave a aperture memory hole
> Please enable the IOMMU option in the BIOS setup
> This costs you 64 MB of RAM
> Mapping aperture over 65536 KB of RAM @ c000000
> PM: Registered nosave memory: 000000000c000000 - 0000000010000000
> 
> 
> My BIOS doesn't have an IOMMU option (latest BIOS available for the
> mboard).  However, it appears that an aperture is allocated but the
> kernel then ignores it due to where it is placed.  Why?
> 

You can't use it as an IOMMU to handle 32-bit devices, since it's above 
the 32-bit addressible region.  Hence the kernel doesn't use it.

	-hpa
