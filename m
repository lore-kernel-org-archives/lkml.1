Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYDIKJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYDIKJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 06:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYDIKJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 06:09:43 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:38725 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYDIKJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 06:09:42 -0400
X-Greylist: delayed 1180 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2008 06:09:42 EDT
From: Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Zhao Forrest" <forrest.zhao@gmail.com>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com, mingo@elte.hu,
       ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com>
	<87iqyro3rc.fsf@basil.nowhere.org>
Date: Wed, 09 Apr 2008 11:50:00 +0200
In-Reply-To: <87iqyro3rc.fsf@basil.nowhere.org> (Andi Kleen's message of "Wed,
	09 Apr 2008 10:01:59 +0200")
Message-ID: <kjmr6dfxsqf.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> "Zhao Forrest" <forrest.zhao@gmail.com> writes:
>>
>> As we can see from above information that the physical memory in system
>> is 32768MB(32GB). However OS is only using about
>> (32768-512)MB(MemTotal:     33010240 kB). Does this mean that this
>> linux kernel can't use the physical memory remapped
>> from (4G-512M, 4G) to (32G, 32G+512M)?
>
> The linux kernel can only use the memory passed to it by the BIOS.
> Sometimes they need special BIOS setup options to enable remapping. If
> there are no such options and you can't upgrade it you're out of luck

Hm, wouldn't the given e820 map and mtrr listing indicate that 512M were
actually remapped to 32G+ in this case?

-- 
								Arne.
