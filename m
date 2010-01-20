Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755Ab0ATCDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0ATCDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 21:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993Ab0ATCDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 21:03:12 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15870 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab0ATCDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 21:03:05 -0500
Message-ID: <4B56641E.1030803@caviumnetworks.com>
Date: Tue, 19 Jan 2010 18:02:06 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: cleanup switches with cases that can be merged
References: <4B56475F.8070608@gmail.com>
In-Reply-To: <4B56475F.8070608@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2010 02:02:07.0189 (UTC) FILETIME=[919F9050:01CA9974]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> I did a search for switch statements with cases that can be merged, but maybe
> some were not intended?
> ---------------->8------------------------------------------8<-----------------
> In these cases the same code was executed.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/mips/include/asm/octeon/octeon-feature.h |    8 ++------
>  arch/mips/kernel/cpu-probe.c                  |    3 ---
>  arch/mips/math-emu/ieee754dp.c                |    1 -
>  arch/mips/math-emu/ieee754sp.c                |    1 -
>  arch/mips/pci/pci-octeon.c                    |    6 ++----
>  arch/mips/powertv/asic/asic_devices.c         |    4 ----
>  arch/mips/sgi-ip32/ip32-irq.c                 |    9 +--------
>  7 files changed, 5 insertions(+), 27 deletions(-)

This patch should be split up.

Octeon, PowerTV, and IP32 are all different architectures.  They should 
be in their own patches.

The two math-emu parts could probably go together.

cpu-probe seems like its own thing.

This brings us to the larger question:  This is just code churn.  Is it 
even worthwhile?


David Daney



