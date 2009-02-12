Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbZBLV0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbZBLV0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZBLV0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:26:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:40802 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbZBLV0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:26:41 -0500
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space
 using pointer derefs.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090212.030926.74125778.davem@davemloft.net>
References: <20090212.021527.12463602.davem@davemloft.net>
	 <1234434959.29851.55.camel@pasglop>
	 <20090212.030926.74125778.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 08:26:03 +1100
Message-Id: <1234473963.29851.65.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 1) The kernel radeon framebuffer driver doesn't mess with
>    the framebuffer endianness setting.
> 
> 2) On >= R300 (which my chip is), Xorg leaves it alone too.

They leave alone the swapper of the engine, not the fb one
(SURFACE_CNTL) afaik.

I dbl checked the other day and it seems that we setup the GART before
we whack it tho but it might be an issue in conjunction with radeonfb
(ie, I don't have radeonfb on my test embedded boards as I rely on X to
POST the cards using ATOMBIOS).

Cheers,
Ben.


