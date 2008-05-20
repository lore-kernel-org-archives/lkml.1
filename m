Return-Path: <linux-kernel-owner+w=401wt.eu-S1763245AbYETLUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763245AbYETLUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbYETLUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:20:24 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:62976 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYETLUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:20:23 -0400
To: Pavel Machek <pavel@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: aperture_64: use symbolic constants
From: Andi Kleen <andi@firstfloor.org>
References: <20080519123952.GA23118@elf.ucw.cz>
Date: Tue, 20 May 2008 13:20:02 +0200
In-Reply-To: <20080519123952.GA23118@elf.ucw.cz> (Pavel Machek's message of "Mon, 19 May 2008 14:39:52 +0200")
Message-ID: <87od71gr31.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 May 2008 11:13:00.0220 (UTC) FILETIME=[76C857C0:01C8BA6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@suse.cz> writes:
>  		if ((last_aper_order && aper_order != last_aper_order) ||
> @@ -303,9 +303,9 @@ void __init early_gart_iommu_check(void)
>  		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
>  			continue;
>  
> -		ctl = read_pci_config(0, num, 3, 0x90);
> +		ctl = read_pci_config(0, num, 3, AMD64_GARTAPERTURECTL);

Strictly "AMD64_" is not the correct prefix, because these registers
are generic standard AGP3 registers.

-Andi
