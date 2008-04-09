Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYDIKQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYDIKQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 06:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYDIKQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 06:16:22 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:38780 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYDIKQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 06:16:21 -0400
From: Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>
To: Andi Kleen <andi@firstfloor.org>
Cc: Zhao Forrest <forrest.zhao@gmail.com>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com, mingo@elte.hu
Subject: Re: Does Linux have plan to support memory hole remapping?
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com>
	<87iqyro3rc.fsf@basil.nowhere.org>
	<kjmr6dfxsqf.fsf@pelargir.dolphinics.no>
	<20080409100331.GH19010@one.firstfloor.org>
Date: Wed, 09 Apr 2008 12:16:20 +0200
In-Reply-To: <20080409100331.GH19010@one.firstfloor.org> (Andi Kleen's message
	of "Wed, 9 Apr 2008 12:03:31 +0200")
Message-ID: <kjmk5j7xrij.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:
> On Wed, Apr 09, 2008 at 11:50:00AM +0200, Arne Georg Gleditsch wrote:
>> Hm, wouldn't the given e820 map and mtrr listing indicate that 512M were
>> actually remapped to 32G+ in this case?
>
> The way it usually works (if it is implemented correctly in the BIOS) 
> is that all memory starting at the hole moves up together 
> (often subject to DIMM boundaries etc.),
> not that the area below the hole is remapped individually.

Yes, bad choice of words on my part.

> BTW it is not actually 512MB that is lost. MemTotal does not 
> include mem_map and that alone is ~512MB (64 bytes for each 4K page)
>
> So as far as I can see there is no missing memory remapping in Zhao's case, 
> he's just confused by the MemTotal semantics.

...meaning that upgrading his BIOS isn't going to change anything for
him, which is what I suspected from the e820 readouts.

-- 
								Arne.
