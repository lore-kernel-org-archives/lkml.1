Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbYL2KCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbYL2KCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYL2KBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:01:53 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:33478 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYL2KBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=Y8LUb0rJ6hcM39O2QIcb2tOTlS38js9QVwd0BLahCs63iuGiDeZze0JjmzgGI0RMCm
         8CoIPkzUUACK6NiGQZevjh4/VBnoVD/Yex5olrZWr/il3n50IomnXKwMAVbWLoN6I/MR
         x1GpwzgKGJb7ii6up+QRNPwJpEsa6RMajq9VA=
Message-ID: <43d009740812290201x30cadf9bx61c525f380746e64@mail.gmail.com>
Date: Mon, 29 Dec 2008 17:01:51 +0700
From: "Igor Podlesny" <for.poige+linux@gmail.com>
Reply-To: for.poige+linux@gmail.com
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: Hi! I've noticed that kernel.org advertises 2.6.28 as "The latest stable version of the Linux kernel is".
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <20081229092124.GA18987@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43d009740812282139x7597aafbn4474455c1aa1e0e8@mail.gmail.com>
	 <20081229092124.GA18987@infradead.org>
X-Google-Sender-Auth: fcdff11b2b39d158
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/29 Christoph Hellwig <hch@infradead.org>:
> On Mon, Dec 29, 2008 at 12:39:55PM +0700, Igor Podlesny wrote:
>> -- Copying several rather big files (~ 25--45 GiB) from XFS on LVM-2
>> on MDraid partition to another one, I had the system rebooted both
>> with 2.6.28 and 2.6.27.10 (accomplished using 2.6.24.7-rt(sic!)25). As
>> you probably understand, that's the case you even can't trace where's
>> the problem, at least on a desktop with GUI, not on server with plain
>> text display. Although, I'm afraid even text display wouldn't had a
>> chance to show anything, tracing that problem.
>
> You don't have 4K_STACKs enabled by default, do you?

	x86_64, so it's not applicable.
	
	I see you've included XFS guys, but that's hard to guess which
sub-system is related to that crash, cause it's a stacked construction
XFS/LVM-2/Linux Software RAID/sata_nv. Also, I've found there were
some complaints bout netfilter's ipt_recent, which I was using, so
I've decided to turn it off and see.
>
> And instead of these rants bug reports would be more useful.
>
	Yeah, I'll try to get backtraces, using null-modem cable, but alas, I
don't have it yet. Nowadays it's not a thing easy to buy at a computer
store. Also, my message (feedback) was written due to concerns bout
quality degradation I saw. May be I was mistaken or not, but I felt
it's better to talk about it to people who really cared and knew.

-- 
End of message. Next message?
