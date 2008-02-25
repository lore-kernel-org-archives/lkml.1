Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYBYWF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYBYWF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbYBYWFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:05:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:28904 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169AbYBYWFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:05:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AudU1Y+s0uyllwu8W0PfRgjSiCvpHE9FakEPDJS/g2P/OEsvJOdbhmYN3V8beZCwwR0db56swlq1+yw94d8X1wxIk/mcWpaKYBV0+QMmedCWZZbhn5JxWczhRxJRYnodz49JBlcUp96+S3ZWmgvKnurONUC4OlwcFhN7tpMGEAM=
Message-ID: <86802c440802251405w7025a8b2na5fde4dcbf56067e@mail.gmail.com>
Date: Mon, 25 Feb 2008 14:05:45 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ravikiran Thirumalai" <kiran@scalemp.com>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
In-Reply-To: <20080225190819.GE3143@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
	 <200802221102.31019.yinghai.lu@sun.com>
	 <47BF1BD9.4020808@firstfloor.org>
	 <200802232148.43255.yinghai.lu@sun.com>
	 <20080224122903.GC13637@one.firstfloor.org>
	 <20080225190819.GE3143@localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:08 AM, Ravikiran Thirumalai
<kiran@scalemp.com> wrote:
> On Sun, Feb 24, 2008 at 01:29:03PM +0100, Andi Kleen wrote:
>  >On Sat, Feb 23, 2008 at 09:48:42PM -0800, Yinghai Lu wrote:
>  >>
>  >> quad core 8 socket system will have apic id lifting.the apic id range could
>  >> be [4, 0x23]. and apic_is_clustered_box will think that need to three clusters
>  >> and that is large than 2. So it is treated as clustered_box.
>  >
>  >Ok I see you chose the quick hack over doing it properly ...
>  >
>  >>
>  >> and will get
>  >>
>  >> Marking TSC unstable due to TSCs unsynchronized
>  >>
>  >> even the CPUs have X86_FEATURE_CONSTANT_TSC set.
>  >
>  >I doubt that will do the right thing on AMD based vSMP,
>  >which also required the cluster check on AMD iirc.
>  >
>
>  Andi, Yes.  AMD based vSMPowered systems uses clustered APICs, and this
>  check base on cpu vendor id is not good :(.

please check if you happy with

http://lkml.org/lkml/2008/2/24/273

Thanks

Yinghai Lu
