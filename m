Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbYGELcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbYGELcP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYGELcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:32:00 -0400
Received: from saeurebad.de ([85.214.36.134]:47193 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYGELb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:31:59 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, uClinux list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH 16/20] m68knommu: use generic show_mem()
References: <20080704160737.750988999@saeurebad.de>
	<20080704161457.056057813@saeurebad.de>
	<Pine.LNX.4.64.0807051010550.5733@anakin>
Date: Sat, 05 Jul 2008 11:30:24 +0000
In-Reply-To: <Pine.LNX.4.64.0807051010550.5733@anakin> (Geert Uytterhoeven's
	message of "Sat, 5 Jul 2008 10:11:21 +0200 (CEST)")
Message-ID: <87d4ls4lgv.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Fri, 4 Jul 2008, Johannes Weiner wrote:
>> Remove arch-specific show_mem() in favor of the generic version.
>> 
>> This also removes the following redundant information display:
>> 
>> 	- free pages, printed by show_free_areas()
>> 	- pages in swapcache, printed by show_swap_cache_info()
>> 
>> where show_mem() calls show_free_areas(), which calls
>> show_swap_cache_info().
>> 
>> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>> CC: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>  arch/m68knommu/mm/init.c |   27 ---------------------------
>
> m68knommu is uClinux.

Uhm, I can not quite follow you here.  Is the CC wrong?

	Hannes
