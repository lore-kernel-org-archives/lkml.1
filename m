Return-Path: <linux-kernel-owner+w=401wt.eu-S934140AbXHAPDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140AbXHAPDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763281AbXHAPDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:03:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49498 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759188AbXHAPDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:03:08 -0400
Message-ID: <46B0A081.5080405@zytor.com>
Date: Wed, 01 Aug 2007 11:02:25 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@novell.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Deprecate a.out ELF interpreters
References: <200708011433.09433.ak@novell.com>
In-Reply-To: <200708011433.09433.ak@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> I propose to deprecate this support and remove for 2.6.25.
> 
> Drawback is that someone still runs their system with a.out ld.so
> they would need to update the ld.so when updating to a new kernel.
> 
> This patch just adds an entry to the deprecation file and a printk
> warning users.
> 
> Comments?
> 

Makes total sense.  This is a highly oddball configuration, and 
*extremely* unlikely to have a significant user base of modern kernels.

It's been 12 years since we switched to ELF.

	-hpa
