Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYH0O5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYH0O5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbYH0O5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:57:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:27139 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbYH0O5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GHE/P4KGCx6JgPrxpB+SdSGBjP5HViNy+u3xI0VU3pTLrXMqIRNfExoj+BVBOVDwb2
         +G5RiwTx+lzLLzGM1AOVUhtf3MxkyoYrQ+PFoug/YVcWGVDe0zI6bKkZ+i7MIfZu1VfV
         XbK2yA1go1y4H9tjijJIGh/8TaTZBrreHCbPo=
Message-ID: <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com>
Date: Wed, 27 Aug 2008 16:57:18 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for August 27
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200808271206.48370.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080827183453.eb651f50.sfr@canb.auug.org.au>
	 <200808271206.48370.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 12:06 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>
> Hi,
>
> On Wednesday 27 August 2008, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since next-20080826:
>
> it fails to build here with:
>
> arch/x86/kernel/cpu/addon_cpuid_features.c: In function 'detect_extended_topology':
> arch/x86/kernel/cpu/addon_cpuid_features.c:119: error: 'struct cpuinfo_x86' hasno member named 'cpu_core_id'
> arch/x86/kernel/cpu/addon_cpuid_features.c:121: error: 'struct cpuinfo_x86' hasno member named 'phys_proc_id'
> arch/x86/kernel/cpu/addon_cpuid_features.c:130: error: 'struct cpuinfo_x86' hasno member named 'phys_proc_id'
> arch/x86/kernel/cpu/addon_cpuid_features.c:133: error: 'struct cpuinfo_x86' hasno member named 'cpu_core_id'
> make[2]: *** [arch/x86/kernel/cpu/addon_cpuid_features.o] Error 1
> make[1]: *** [arch/x86/kernel/cpu] Error 2
> make: *** [arch/x86/kernel] Error 2

which is most likely already fixed in x86 tree by

http://lkml.org/lkml/2008/8/27/34
