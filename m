Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZAGABT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZAGABT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZAGABK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:01:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:31233 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZAGABJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:01:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Um+FC/ygUkNCO5wcwwSrzPPrUjK7HGNygDH0pAbcdjf7zSiUNwuSNO8TycwjPByhsb
         zBWLnImXRsMi7GQMe1wUheA247YI6HkrUxZ+NwJ4jePiyj60nWJSyQRbi9A4mJpM7HKR
         UtGK6aQ0Sv8Ko7rYeLU+Sl+385zs9BXZ/2jeU=
Message-ID: <e9c3a7c20901061601v4399c2bft5d5ba8929f3b1d58@mail.gmail.com>
Date: Tue, 6 Jan 2009 17:01:07 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.29 -mm merge plans
Cc: linux-kernel@vger.kernel.org, "Ralf Baechle" <ralf@linux-mips.org>,
       "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090105004300.19ed52d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
X-Google-Sender-Auth: b2643bb6c96d4989
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2009 at 1:43 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> dmatest-flush-and-invalidate-destination-buffer-before-dma.patch

Please drop this one for now.  There is an open question to Ralf [1]
over whether the MIPS dma_map_single() implementation should behave
more like ARM's i.e flush and invalidate partial cachelines in the
DMA_FROM_DEVICE case.  Currently it only invalidates.

Thanks,
Dan

[1] http://marc.info/?l=linux-kernel&m=123120765106336&w=2
