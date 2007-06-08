Return-Path: <linux-kernel-owner+w=401wt.eu-S967721AbXFHDoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967721AbXFHDoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967133AbXFHDoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:44:17 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967126AbXFHDoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:44:17 -0400
Message-ID: <4668D089.5090209@zytor.com>
Date: Thu, 07 Jun 2007 20:44:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mark Lord <lkml@rtr.ca>, Andi Kleen <ak@suse.de>
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
References: <20070608023551.GJ15426@holomorphy.com> <20070607194156.d4aacf4c.akpm@linux-foundation.org> <20070608030629.GW6909@holomorphy.com> <4668CF2E.8000707@zytor.com> <20070608034121.GX6909@holomorphy.com>
In-Reply-To: <20070608034121.GX6909@holomorphy.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> William Lee Irwin III wrote:
>>> !CONFIG_X86_PAE && CONFIG_HIGHMEM64G doesn't make sense and is not allowed
>>> by this patch. CONFIG_X86_PAE && !CONFIG_HIGHMEM64G works here.
> 
> 
> On Thu, Jun 07, 2007 at 08:38:22PM -0700, H. Peter Anvin wrote:
>> But what's the point?
>> If you're going to divorce these, at least do it in a way that makes
>> sense, specifically the two independent variables are PAE and HIGHMEM.
>> PAE and !HIGHMEM does make (some amount of) sense, due to no kmap overhead.
> 
> Beg your pardon? Are you reading the patch description correctly?
> 

I mean, with your patch CONFIG_HIGHMEM4G versus CONFIG_HIGHMEM64G really
don't make sense as separate selections anymore.

	-hpa
