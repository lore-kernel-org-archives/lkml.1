Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab0BAJcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:32:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:25372 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0BAJbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:31:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=gTOxvn5hyXwas+4q5jC9Ctm9iR+XqevSZsbQaKGkYf3EHBdb7fmk967zf+oFV6DbrM
         9Rhk7PBAQd4m+cHnobjWFxvEnLJHuNpBMhUmVCdXYms/0RkIK1zmZysqMDF1k9NwKewC
         sVtRWji0VgkiqxgNADTsmRfVQHI6oL/zMLfPQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/68] ide2libata
Date: Mon, 1 Feb 2010 10:31:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: alan@lxorguk.ukuu.org.uk, jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100129160308.21495.14120.sendpatchset@localhost> <20100129232540.41f6c4f6@lxorguk.ukuu.org.uk> <20100131.234726.124893364.davem@davemloft.net>
In-Reply-To: <20100131.234726.124893364.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <201002011031.19741.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010 08:47:26 am David Miller wrote:

> However what I don't like is how this is implemented.  We shouldn't
> pretend the data structures are the same by using macros in some
> header file, we should truly abstract out the data types properly such
> that these drivers in fact use the same datastructures.

The hardest part is done and the idea is proved so this indeed would be
a natural next step..

> For the price of a few series of data structure morphs, we eliminate
> the tester-base issue of legacy IDE.  There's one driver for both
> ATA and legacy IDE, the stuff in front is just a presentation and
> probing layer, nothing more.

Hmm.. sounds exactly like the direction in which IDE has been going for
the last few years.. :)

--
Bartlomiej Zolnierkiewicz
