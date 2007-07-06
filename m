Return-Path: <linux-kernel-owner+w=401wt.eu-S1762271AbXGFOz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271AbXGFOz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbXGFOzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:55:22 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:26025 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbXGFOzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TnOFkPFzW5nopLOki/jhMPYuAha21ObTCNbftm0Ci8n83X/vC79DXIkqbWRPvMfqKQEWcGNObc/+NlYhoNTzmZlrQrEm3nfb08ThGg+9djGD4+J9oxPVdF62fpL1e5P5TN1Gl8ylCEiWCGt5kQ9Mhd6kVnrIcFmM6aWpvhNJaCM=
Message-ID: <8bd0f97a0707060755q59a8fdc5j3c0d44e060eec9cf@mail.gmail.com>
Date: Fri, 6 Jul 2007 09:55:20 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: dead CONFIG variables in kernel Makefiles
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707060553350.10501@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707060553350.10501@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
>   in addition to references to non-existent CONFIG variables in header
> and source files, here's a list of such variables in Makefiles
> throughout the entire tree:
>
> ===== BF548 =====
> ./arch/blackfin/Makefile:cpu-$(CONFIG_BF548) := bf548
> ===== BF549 =====
> ./arch/blackfin/Makefile:cpu-$(CONFIG_BF549) := bf549
> ===== BF_REV_0_0 =====
> ./arch/blackfin/Makefile:rev-$(CONFIG_BF_REV_0_0)  := 0.0
> ===== BF_REV_0_1 =====
> ./arch/blackfin/Makefile:rev-$(CONFIG_BF_REV_0_1)  := 0.1

that's because we couldnt push the rest of the BF54x port until the
new merge window ... they'll be defined with 2.6.23

> ===== CPU_FREQ_BF533 =====
> ./arch/blackfin/mach-bf533/Makefile:obj-$(CONFIG_CPU_FREQ_BF533) += cpu.o

we changed names in the Kconfig but didnt sync that Makefile ... the
others got updated
-mike
