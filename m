Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbZEDX0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbZEDX0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZEDX0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:26:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56191 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbZEDX0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:26:45 -0400
Message-ID: <49FF7977.6010609@redhat.com>
Date: Mon, 04 May 2009 20:25:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/21] amd64_edac: add f10-and-later methods-p2
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-13-git-send-email-borislav.petkov@amd.com>
In-Reply-To: <1241024107-14535-13-git-send-email-borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov escreveu:
> +/*
> + * f10_lookup_addr_in_dct
> + *
> + *	Iterate over the DRAM DCT "base" and "mask" register looking for
> + *	a SystemAddr match on the specified 'ChannelSelect' and 'NodeID'
> + *
> + * Return:
> + *	-1  NOT FOUND
> + *	0..csrow = Chip-Select Row
> + */
> +static int f10_lookup_addr_in_dct(u32 InputAddr, u32 NodeID, u32 ChannelSelect)
> +{
> +	struct mem_ctl_info *mci;
> +	struct amd64_pvt *pvt;
> +	u32 CSBase, CSMask;
> +	int CSFound = -1;
> +	int csrow;
> +
> +	mci = mci_lookup[NodeID];
> +	if (!mci)
> +		return CSFound;
>   

It is better to use a standard error code like -EINVAL instead of using 
-1 for error.


Cheers,
Mauro.
