Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbXGDDxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbXGDDxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 23:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbXGDDxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 23:53:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:46602 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbXGDDxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 23:53:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ib75as+QqwpJpEVE5d05HWgATQkGfNK2yLMz2TqTqM70wtSZQn/ksHCI8oO8y1v+xQnb+M8ZAuz2b4cbZXhr0+XJBF46wFf3+d+aXyq0EvExYVMKmZgqqYkjq9U/81ZHr9NyCH3tfXGYFAE5aZJw8O3N6m5TV3d3Zas4krveBeM=
Message-ID: <468B19BA.6030202@gmail.com>
Date: Wed, 04 Jul 2007 12:53:30 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: 7091@blargh.com
CC: linux-ide@vger.kernel.org, jgarzik@pobox.com, ak@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sata_sil, writing bug with multiple cards?
References: <courier.4689EFD9.0000589A@blargh.com>            <468A0E24.7020000@gmail.com>            <courier.468B005A.0000127A@blargh.com>            <courier.468B1258.000018F4@blargh.com> <courier.468B17B1.00001A78@blargh.com>
In-Reply-To: <courier.468B17B1.00001A78@blargh.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

7091@blargh.com wrote:
> Apologies for the chain-replying to myself, just replying as I think of
> things to try.
> 7091@blargh.com writes:
>> Here's an odd data point. 
>> I just broke that array, formatted all three of those partitions
>> seperately, mounted and did my ISO copy test. 
>> All three drives, run one at a time, function fine.  No corruption.
> 
> Here's another odd one.  I did the following:
> # Mount all 3 drives as individuals...
> mount /dev/sda1 /mnt/a
> mount /dev/sdb1 /mnt/b
> mount /dev/sdc1 /mnt/c
> # Copy the same file to all three drives at the same time
> cp KNOPPIX_V5.1.0CD-2006-12-30-EN.iso a/kn10.iso &
> cp KNOPPIX_V5.1.0CD-2006-12-30-EN.iso b/kn10.iso &
> cp KNOPPIX_V5.1.0CD-2006-12-30-EN.iso c/kn10.iso &
> Got massive corruption.

Hmmm... I don't think this is sata_sil driver bug.  cc'ing Andi Kleen
and lkml.  Andi, the original thread can be read from

http://thread.gmane.org/gmane.linux.ide/20213

Any ideas?

-- 
tejun
