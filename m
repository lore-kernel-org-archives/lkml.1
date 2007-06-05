Return-Path: <linux-kernel-owner+w=401wt.eu-S1763949AbXFENTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763949AbXFENTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbXFENTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:19:00 -0400
Received: from lucidpixels.com ([75.144.35.66]:49077 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758872AbXFENS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:18:59 -0400
Date: Tue, 5 Jun 2007 09:18:58 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Andi Kleen <andi@firstfloor.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't
 the kernel realize the BIOS has problems and re-map appropriately?
In-Reply-To: <20070605094623.GA23274@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0706050918160.16952@p34.internal.lan>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
 <200706011407.51779.jbarnes@virtuousgeek.org> <20070601211943.GO7217@one.firstfloor.org>
 <200706011441.57149.jbarnes@virtuousgeek.org> <m1r6orwptz.fsf@ebiederm.dsl.xmission.com>
 <Pine.LNX.4.64.0706041420100.25811@p34.internal.lan>
 <20070604201823.7b7cb328@the-village.bc.nu> <m1myzfwi0x.fsf@ebiederm.dsl.xmission.com>
 <86802c440706041759q1b2d528ex24b3de514d09d9ef@mail.gmail.com>
 <m1ejkrw576.fsf@ebiederm.dsl.xmission.com> <20070605094623.GA23274@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jun 2007, Andi Kleen wrote:

>> So the only safe thing we can do is not use memory that is not
>> write-back cached.  That we can positively detect and is a
>> conservative action so if anything will work that will.
>
> Jesse wrote such a patch (or rather it limitted end_pfn), but it broke
> the X server for so far unknown reasons.
>
> -Andi
>

So the best solution is for a patch/function that calculates the E820 
memory map subtracts the non-cached memory and does the equivilant of 
append= in LILO config with the proper amount of memory?

Justin.
