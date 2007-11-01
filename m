Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbXKAWz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbXKAWz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXKAWzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:55:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:27341 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbXKAWzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bPYl1vNF7bqLbDKZy1HFtD2loIl7jh0kWLvKuPubg3Sx1/U/YM9t2j6dqgVto0CLn/kbOyE1kSoZl2ZrxV5vuBWh99yFbvjwwGps+rQ8Qv2/2yIt/YeO3AI5jrgJNbVAxJG0oAPSRgNGBevKFFl3xcJo5PUi5qTLipgVlORfrXo=
Message-ID: <2ed59cbb0711011555u4bd5f176ha980042bf321df63@mail.gmail.com>
Date: Thu, 1 Nov 2007 18:55:12 -0400
From: "Zurk Tech" <zurktech@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Quad core CPU detected but shows as single core in 2.6.23.1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071101133856.d97ce4f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2ed59cbb0710250750w73d2b29dwee0f1038fa9dff18@mail.gmail.com>
	 <20071101133856.d97ce4f0.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i have no clue. thats why im not a kernel dev. :)
but its fixed now by a simple gart setting to disabled in bios so its
ok. mobo is s3992 tyan h2000 and bios is downloadable on tyans
website..2.x i think.
-Z-

On 11/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 25 Oct 2007 10:50:50 -0400
> "Zurk Tech" <zurktech@gmail.com> wrote:
>
> > duh. never mind. i had an attack of the stupids and enabled GART error
> > reporting in the bios menu when i installed the motherboard. fixed
> > now. shows all 4 and 8 on the other one.
>
> Confused.  Why should that cause the kernel to misreport the core
> count?
>
