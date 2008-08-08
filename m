Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYHHPFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYHHPFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYHHPFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:05:24 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:45093 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432AbYHHPFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:05:24 -0400
Message-ID: <489C60B1.2080909@blueyonder.co.uk>
Date: Fri, 08 Aug 2008 16:05:21 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org
Subject: Re: A question regarding init_mm
References: <489BA629.4030008@blueyonder.co.uk> <71281.1218166772@turing-police.cc.vt.edu>
In-Reply-To: <71281.1218166772@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Fri, 08 Aug 2008 02:49:29 BST, Sid Boyce said:
>
>> EXPORT_UNUSED_SYMBOL(init_mm); /* will be removed in 2.6.26 */
>
>> Any thoughts on why it's not seen? No one on the nvidia list has a clue
>> either.
>
> Run a kernel built with 'CONFIG_UNUSED_SYMBOLS=y', that should help matters
> somewhat.
>
> The *real* problem is that the NVidia driver uses the deprecated pgd_offset_k()
> function (see NV_PGD_OFFSET in lv-linux.h).  That's what needs fixing.

Thanks, that solved the problem. There is a patch for NVidia 177.13 
which works, but I haven't yet been able to read it through to see 
exactly what files were altered.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

