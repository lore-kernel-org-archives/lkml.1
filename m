Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbXF0LoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbXF0LoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 07:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXF0LoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 07:44:10 -0400
Received: from lucidpixels.com ([75.144.35.66]:55514 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXF0LoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 07:44:10 -0400
Date: Wed, 27 Jun 2007 07:44:08 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <46824CA5.2020908@macroscoop.nl>
Message-ID: <Pine.LNX.4.64.0706270743560.25629@p34.internal.lan>
References: <200706251434.43863.jesse.barnes@intel.com> <46823F71.6060200@macroscoop.nl>
 <20070627112216.GA31708@one.firstfloor.org> <46824CA5.2020908@macroscoop.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jun 2007, Pim Zandbergen wrote:

> Andi Kleen wrote:
>
>> That's impossible. Either it limited your RAM or it didn't change anything.
>
> OK, maybe it's cosmetic, but I would not expect a negative number
>
> With old BIOS it printed
> **** MTRRs don't cover all of memory, trimmed 196608 pages
>
> with new BIOS it prints
> **** MTRRs don't cover all of memory, trimmed -65536 pages
>
> Pim
>

It works ok for me:

[    0.000000] **** MTRRs don't cover all of memory, trimmed 16384 pages

This is using his latest patch with 2.6.22-rc6.

Justin.
