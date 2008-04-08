Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbYDHJrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbYDHJrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYDHJrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:47:17 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:44679 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYDHJrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=txwoZcVj4OsbOH6D6AVLGcmG/zvdr0819s2r/9V+Dt7HaNvck+R/uccjRX2phOQa2e5Luc+/wcgD5d8VrhPXm3Q/w9dncA0k+A+ZfZhHcPGb65lCPfsIJJfWH/SwO0cXcPI4gWdoGErlfGdrMMUpdsU5pncTZshzIw07tCdea6s=
Message-ID: <f17812d70804080247k584ecacbvef5ee883f432aa89@mail.gmail.com>
Date: Tue, 8 Apr 2008 17:47:14 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 4/4] pxafb: preliminary smart panel interface support
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-arm-kernel email list" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>, "Daniel Mack" <daniel@caiaq.de>
In-Reply-To: <20080408091635.GA23165@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70804072107k77c2642ah23c8f2ce9535159f@mail.gmail.com>
	 <20080408012359.d0a7d0c8.akpm@linux-foundation.org>
	 <f17812d70804080134kaeefa59tf4dc583afcc384e7@mail.gmail.com>
	 <20080408091635.GA23165@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 5:16 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Apr 08, 2008 at 04:34:05PM +0800, eric miao wrote:
>
> > >From 3b14d02739b98ed8be3904914dd8b9d4a39fff25 Mon Sep 17 00:00:00 2001
>  > From: Eric Miao <eric.miao@marvell.com>
>  > Date: Mon, 7 Apr 2008 15:57:56 +0800
>  > Subject: [PATCH] pxafb: preliminary smart panel interface support
>  >
>  > Signed-off-by: Daniel Mack <daniel@caiaq.de>
>  > Acked-by: Eric Miao <eric.miao@marvell.com>
>  > ---
>  > Andrew: please see if this modified version applies: FB_PXA_SMARTPANEL
>  > defaults to "n" and removed the cast to void *, thanks    - eric
>
>  No need to add an explicit "default n" - defaulting to 'n' is the
>  default unless otherwise set.
>

Yes, indeed. I'd like to address this issue in the next patch to abstract
the output interface.

-- 
Cheers
- eric
