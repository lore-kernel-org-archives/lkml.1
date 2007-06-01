Return-Path: <linux-kernel-owner+w=401wt.eu-S1764271AbXFAUTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764271AbXFAUTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762537AbXFAUT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:19:28 -0400
Received: from lucidpixels.com ([75.144.35.66]:56361 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762382AbXFAUT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:19:27 -0400
Date: Fri, 1 Jun 2007 16:19:26 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Andi Kleen <andi@firstfloor.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't
 the kernel realize the BIOS has problems and re-map appropriately?
In-Reply-To: <p73k5unbcnq.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0706011618270.7446@p34.internal.lan>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
 <200706011210.15808.jbarnes@virtuousgeek.org> <p73k5unbcnq.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Andi Kleen wrote:

> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
>
>> (or we get proper PAT support, which I think would make this problem
>> go away as well).
>
> No it won't. If the basic MTRRs for memory are wrong just having PAT support
> in drivers (which already exist in a limited form already, just for
> UC only) won't change anything.
>
> -Andi
>

Basically from what I read:

1. The MCH/ICH8 hub 'requires' a minimum of 512MB to run, the board manual 
states it needs at least 512MB of memort.
2. The DVT/IGP graphics uses either 128MB or 256MB, I have it set to 
128MB.

How can the Linux kernel find this out/poll this information so users do 
not have to know mem=XXXXM?

Justin.
