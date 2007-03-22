Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbXCVQYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbXCVQYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934094AbXCVQYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:24:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:13032 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933913AbXCVQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:24:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xc2zAcJS/O+I+b8sgYJbVRDBXsB4tP4Bh8V5JuINpB86RhmRox/x0fN2MNEfK2OtgjKYKWsCshpgttnAeG6ib4L9E1J9F4VAWt9lGWYQfUeLJjZLAIjIGG9EEN4YVjVRhU4xLy9bKVO28pvb3qEI1vMtyclV7dJUl1HL9k5Kkcw=
Message-ID: <a44ae5cd0703220924h20f6cd1bsc4d7b354b61859d4@mail.gmail.com>
Date: Thu, 22 Mar 2007 09:24:38 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc4-mm1 + 4 hotfixes -- BUG: unable to handle kernel paging request at virtual address 6b6b6ceb -- EIP is at module_put+0x7/0x1f
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
In-Reply-To: <20070322012836.8e1a0d10.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0703220029lb4df507ne21da177f7c05008@mail.gmail.com>
	 <20070321234456.946d1742.akpm@linux-foundation.org>
	 <a44ae5cd0703220114r42dd1954t3a4e1357d5ff71d6@mail.gmail.com>
	 <20070322012836.8e1a0d10.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I cannot reproduce the BUG with your ml.bz2 patch applied.
I am seeing this with both 2.6.21-rc4-mm1 + hotfixes, and with
2.6.21-rc4 + ml.bz2:

Mar 22 09:10:35 FractalPath kernel: ACPI: CPU0 (power states: C1[C1]
C2[C2] C3[C3])
Mar 22 09:10:35 FractalPath kernel: The kobject at, or inside
per_cpu__cpuidle_devices+0x40/0x558 is not dynamically allocated.
Mar 22 09:10:35 FractalPath kernel: The kobject at, or inside
per_cpu__cpuidle_devices+0xd4/0x558 is not dynamically allocated.
Mar 22 09:10:35 FractalPath kernel: The kobject at, or inside
per_cpu__cpuidle_devices+0x168/0x558 is not dynamically allocated.
Mar 22 09:10:35 FractalPath kernel: cpuidle: using driver acpi_idle

Not sure if this is a problem.  Also, the first time I booted the ml.bz2
build, it hung.  I don't have netconsole or a serial debugging system
set up, so I have no idea what the problem was.  The second boot,
ipw2200 loaded with no errors, but NetworkManager wouldn't
connect until I removed and reinserted the module.

All the best,
           Miles
