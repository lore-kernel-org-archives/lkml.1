Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbZCPTS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbZCPTS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZCPTSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:18:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:15092 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZCPTSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O+WyncDkFjbqRdrXDodeMrGL+2bcY9rC5pW1K/x+Y9/Lr51y6ASXREGFL7oI8M5PTB
         WhH/DK3+kJqEwlofWVQu8gF5+1QX6UGXqNdCGqXHFmb2zYSv100u1jeAPVlSjdVPYC5y
         oBxccx/SDNTXJmYGOQ/U7MZ3xqamQMJoLvXY0=
MIME-Version: 1.0
In-Reply-To: <43e72e890903161215u343cbb19v6d6cbf36794e252a@mail.gmail.com>
References: <43e72e890903161215u343cbb19v6d6cbf36794e252a@mail.gmail.com>
Date: Mon, 16 Mar 2009 12:18:12 -0700
Message-ID: <43e72e890903161218o6896e58bqadc7e80f6a975bc0@mail.gmail.com>
Subject: Re: AMD Quad core - PCI-DMA: Out of IOMMU space on > 4 GB RAM
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>, joerg.roedel@amd.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:15 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> I've run into "PCI-DMA: Out of IOMMU space" messages after loading and
> unloading a module 30 times. The interesting thing is this only
> happens if I have > 4 GB of memory. The box this occurs has AMD Phenom
> quad core CPU so I take it a harware IOMMU is being used. Below are
> example relevant messages with > 4 GB and then < 4 GB of memory. The
> driver I tested this with was ath9k. It could be an issue perhaps with
> ath9k but I am unable to find an issue in our probe/removal.
>
> Could this be an issue with the AMD IOMMU used? Or is it more likely a
> driver issue?

I forgot to mention I'm using l Linus 2.6.29-rc8 with some
serialization patches applied for ath9k (which are unrelated to
DMA/IOMMU/probe) [1].

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-03-12/serialization-v6/for-2.6.29/

  Luis
