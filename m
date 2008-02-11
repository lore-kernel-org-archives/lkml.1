Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbYBKFWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbYBKFWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 00:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYBKFWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 00:22:16 -0500
Received: from rex.snapgear.com ([203.143.235.140]:52993 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751494AbYBKFWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 00:22:15 -0500
Message-ID: <47AFDB83.2010209@snapgear.com>
Date: Mon, 11 Feb 2008 15:22:11 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: schwidefsky@de.ibm.com
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: m68knommu compile error
References: <20080208222516.GC6505@cs181133002.pp.htv.fi>	 <1202552472.8936.7.camel@localhost> <1202554715.8936.18.camel@localhost>
In-Reply-To: <1202554715.8936.18.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Martin Schwidefsky wrote:
> On Sat, 2008-02-09 at 11:21 +0100, Martin Schwidefsky wrote:
>> On Sat, 2008-02-09 at 00:25 +0200, Adrian Bunk wrote:
>>> Commit 2f569afd9ced9ebec9a6eb3dbf6f83429be0a7b4 breaks m68knommu:
>> Does the patch below fixes the problem? I tried to cross compile for
>> m68knommu but it seems like you need a special m68k compiler to get it
>> compile all the way through. With the patch it did fail with a different
>> error, so I assume it is fixed. The problem is that the pgtable_t is
>> simply missing for m68knommu, I must have overlooked a reject for one of
>> the constant regenerations of the patch to keep up with upstream. Sorry
>> about that.
> 
> This is a problem for all nommu architectures. The patch fixed all four
> of them.

Confirmed, good for m68knommu.

Acked-by: Greg Ungerer <gerg@uclinux.org>



-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
