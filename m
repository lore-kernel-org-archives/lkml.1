Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYCHBqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYCHBqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYCHBp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:45:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:10073 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYCHBpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:45:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CTKeGGCSadw6vCVNf1X20BbGPJXXl8JpBkLJ/i5CKWa+W6Pr/B3nEhFGv/MTohsPMlcv/JPtU+pBDJGHMfE7qtEPHlX/TMvA9Zo5Qz/+tVH68fLHrgc2PZdk3pkqRcdmxPsSUO+7SuJwjtavhT+VDTmktAyfh+SPVdY1TE9Pmyo=
Message-ID: <86802c440803071745l33584535jb998b262e59a915a@mail.gmail.com>
Date: Fri, 7 Mar 2008 17:45:54 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: reserve dma32 early for gart
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200803080020.50474.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803071502o50a06199i6afeb5996f207c6d@mail.gmail.com>
	 <200803080020.50474.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2008 at 3:20 PM, Andi Kleen <ak@suse.de> wrote:
> On Saturday 08 March 2008 00:02:50 Yinghai Lu wrote:
>  >
>  >
>
>
>
>  >solution will be:
>  >1. make memmap allocation get memory above 4G...
>  >2. reserve some dma32 range early before we try to set up memmap for all.
>  >and release that before pci_iommu_alloc, so gart or swiotlb could get some
>  >range under 4g limit for sure.
>
>  Funny we had (1) before vmemmap for some time, but it looks like
>  that regressed with vmemmap Anyways I think (1) alone should be enough, is (2)
>  really needed?

even vmemmap is disabled, still need (2).

(1) is not there yet.

YH
