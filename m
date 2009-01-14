Return-Path: <linux-kernel-owner+w=401wt.eu-S1764030AbZANQOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764030AbZANQOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763860AbZANQOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:14:42 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:47867 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763725AbZANQOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:14:40 -0500
X-IronPort-AV: E=Sophos;i="4.37,263,1231113600"; 
   d="scan'208";a="128875512"
From: Roland Dreier <rdreier@cisco.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: "James Kirin" <james.kirin40@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: memory beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y
References: <baeb34bc0901131746n33cd536co331e32361df2fb72@mail.gmail.com>
	<adaeiz6k4o4.fsf@cisco.com>
	<baeb34bc0901131910n55cae670qc9d02c9f78c6432@mail.gmail.com>
	<86802c440901132207l433227d9nf149506012a5721e@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 14 Jan 2009 08:14:35 -0800
In-Reply-To: <86802c440901132207l433227d9nf149506012a5721e@mail.gmail.com>
	(Yinghai Lu's message of "Tue, 13 Jan 2009 22:07:26 -0800")
Message-ID: <ada63khkgpg.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jan 2009 16:14:35.0952 (UTC) FILETIME=[31682B00:01C97663]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > please do
 > 1. boot linux with "disable_mtrr_trim" in grub.conf etc
 > 2. after booting input:
 > echo "base=0x100000000 size=0x20000000 type=write-back" >/proc/mtrr

Is there any way we can have the kernel do this automatically if there
are any free mtrr slots?  I would guess this type of BIOS bug is pretty
common (desktop boards not validated with > 4GB of RAM), and having the
kernel throw away 4GB of memory unless the user does some fancy
scripting is not very friendly (not to mention the fact that things are
likely to be very slow until the mtrr fixup script runs).

 - R.
