Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZANSRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZANSRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZANSRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:17:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:38525 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbZANSRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:17:20 -0500
Message-ID: <496E2C11.3000200@kernel.org>
Date: Wed, 14 Jan 2009 10:16:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: James Kirin <james.kirin40@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: memory beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y
References: <baeb34bc0901131746n33cd536co331e32361df2fb72@mail.gmail.com>	<adaeiz6k4o4.fsf@cisco.com>	<baeb34bc0901131910n55cae670qc9d02c9f78c6432@mail.gmail.com>	<86802c440901132207l433227d9nf149506012a5721e@mail.gmail.com> <ada63khkgpg.fsf@cisco.com>
In-Reply-To: <ada63khkgpg.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > please do
>  > 1. boot linux with "disable_mtrr_trim" in grub.conf etc
>  > 2. after booting input:
>  > echo "base=0x100000000 size=0x20000000 type=write-back" >/proc/mtrr
> 
> Is there any way we can have the kernel do this automatically if there
> are any free mtrr slots?  I would guess this type of BIOS bug is pretty
> common (desktop boards not validated with > 4GB of RAM), and having the
> kernel throw away 4GB of memory unless the user does some fancy
> scripting is not very friendly (not to mention the fact that things are
> likely to be very slow until the mtrr fixup script runs).

could do it. aka make mtrr and e820 consistent.
it depends which one that we trust mtrr or e820.

YH
