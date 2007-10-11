Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbXJKVap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbXJKVap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbXJKVai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:30:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbXJKVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:30:37 -0400
Message-ID: <470E95E9.5060703@zytor.com>
Date: Thu, 11 Oct 2007 14:30:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: zach@vmware.com, patches@x86-64.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [6/12] x86_64: Early segment setup for VT
References: <20070809241.425881000@suse.de> <20070809124133.D559014F3B@wotan.suse.de>
In-Reply-To: <20070809124133.D559014F3B@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Zachary Amsden <zach@vmware.com>
> 
> VT is very picky about when it can enter execution.
> Get all segments setup and get LDT and TR into valid state to allow
> VT execution under VMware and KVM (untested).
> 
> This makes the boot decompression run under VT, which makes it several
> orders of magnitude faster on 64-bit Intel hardware.
> 
> Before, I was seeing times up to a minute or more to decompress a 1.3MB kernel
> on a very fast box.
> 
> Signed-off-by: Zachary Amsden <zach@vmware.com>
> Signed-off-by: Andi Kleen <ak@suse.de>
> 

Makes a lot of sense to me.

	-hpa
