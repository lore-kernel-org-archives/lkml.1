Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbXJZIjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbXJZIjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 04:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbXJZIjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 04:39:09 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:43669 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbXJZIjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 04:39:08 -0400
X-Greylist: delayed 1866 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 04:39:07 EDT
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Opteron box and 4Gb memory
References: <20071025230904.03d5f46a@werewolf> <47211172.9070606@zytor.com>
	<20071026004434.50c73dd3@werewolf>
From: Arne Georg Gleditsch <argggh@dolphinics.no>
Date: Fri, 26 Oct 2007 10:08:08 +0200
In-Reply-To: <20071026004434.50c73dd3@werewolf> ("J.A. =?iso-8859-1?Q?Maga?=
 =?iso-8859-1?Q?ll=F3n=22's?= message of "Fri\, 26 Oct 2007 00\:44\:34
 +0200")
Message-ID: <kjmsl3yuwlz.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"J.A. Magallón" <jamagallon@ono.com> writes:
> Software Memory Hole
> When "Enabled", allows software memory remapping around the memory
> hole. Options are Enabled and Disabled.
>
> Hardware Memory Hole
> When "Enabled", allows software memory remapping around the memory
> hole. Options are Enabled and Disabled. Note: this is only supported by
> Rev E0 processors and above.
> ( I have two Opteron 275 processors, no idea about revision)

The configuration register used to to reclaim DRAM lost to an MMIO
hole was introduced with revision E of the gen1 Opterons.  (This
feature is supposed to work both in interleaved and non-interleaved
mode.)  What does /proc/cpuinfo say?  (On both?)

(Still, even without this your BIOS should be able to map your memory
so that you are able to use all 4G.  Provided you disable
interleaving, I can't see that there's anything stopping the BIOS from
mapping the memory from node 1 to 0-2G and the memory from node 2 to
4-6G, leaving a 2G hole for MMIO and other junk.  Whether your BIOS
actually supports this is another matter.)

-- 
								Arne.
