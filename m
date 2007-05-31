Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbXEaA5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbXEaA5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbXEaA5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:57:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:18731 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbXEaA5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qaTIkW7W4NtWNpOwOiRoSMEJ3U9TmSns1PVQ7MqhpzV2wBsT2hds+ft40hf+jP03JPRywpD+IjnKWC8NcsPWRp+6iOB9Lp/rgtSYwnhnNpyrdXKq1NmGZe06ejFz6CfBO8WyQeHd5mlhpugoXlemtksWRIQiouDWCBi8AUv/c2k=
Message-ID: <82e4877d0705301757v580a4ca5yebe2a565f0b97552@mail.gmail.com>
Date: Wed, 30 May 2007 20:57:41 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>, jpiszcz@lucidpixels.com,
       linux-kernel@vger.kernel.org
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of RAM on Intel 965WH motherboards. (FULL DMESG)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:


> 0-3319MB
> 4096-8832MB
>
> leaving 64MB of memory at the top of RAM uncached. What do you want to
> bet that something important (kernel code?) is getting loaded there..
>
> So essentially it's a BIOS problem, it's not setting up the MTRRs
> properly in order to map all of RAM as cacheable. As Andi says, complain
> to Intel.
>

Could the BADRAM patch be useful for him?
http://rick.vanrein.org/linux/badram/download.html has 2.6.21 version.
It says it supports x86_64. May be using this patch he can exclude
that RAM from being used/accessed?

Parag
--
