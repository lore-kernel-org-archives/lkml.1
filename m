Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbYLBU5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYLBU5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYLBU5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:57:11 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:16833 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYLBU5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:57:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SntQq/cxGEnKBe1Ue4BVclv45czyeN3YFOV0G0f9aLq9l5Gv0pGApz3CwITVaLYPxT
         CXqUg/4LwN5Upp/3/7Yg9JlbC1ItyZhvX4Mri5jMvPmxxGDlz6k3QrjleJQk2qzNChzD
         hEr2stZxUKBmcwqPXhbInAr0RDMbAUwPDFc6U=
Message-ID: <43e72e890812021257p761ab16dqa2058c711349a462@mail.gmail.com>
Date: Tue, 2 Dec 2008 12:57:07 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: stable@kernel.org
Subject: Re: [ath9k-devel] [PATCH 0/3] ath9k: several fixes ported to 2.6.27
Cc: sfr@canb.auug.org.au, ath9k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 12:51 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This fixes a few issues seen on MacBook Pros:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=11811
>
> I've ported them to 2.6.27 to help with them being applied sooner.
> I've tried to keep them as small as possible. I don't have the
> ports for 2.6.28 though I think John will be sending them soon
> through his pending-fixes branch.
>
> These are already applied on wireless-testing.

Oh sorry, I noticed patch 2 and 3 didn't go with the subject to
indicate their order. The order they should be applied in is:

0001-ath9k-Fix-SW-IOMMU-bounce-buffer-starvation.patch
0002-ath9k-correct-expected-max-RX-buffer-size.patch
0003-ath9k-Handle-ENOMEM-on-RX-gracefully.patch

You can also find these here:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2008-11-22/27-IOMMU-01/

  Luis
