Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbZBPVAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbZBPVAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZBPVAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:00:41 -0500
Received: from gw.goop.org ([64.81.55.164]:56910 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbZBPVAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:00:40 -0500
Message-ID: <4999D3F6.9070802@goop.org>
Date: Mon, 16 Feb 2009 13:00:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 headers: include linux/types.h
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu> <20090213122325.GA30061@elte.hu> <20090213122724.GA2172@elte.hu> <49959EFA.8040507@goop.org> <20090213180924.GD18581@elte.hu>
In-Reply-To: <20090213180924.GD18581@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> likewise, PUD_PAGE_* and PAGETABLE_LEVELS should move to pgtable_types.h
> too i guess. Same goes for *MASK_SHIFT*.

Hm, iffy.  I think those are getting more to the larger-scale virtual 
and physical memory layout for the machine: the various page sizes 
available and the number of P and V bits.

    J
