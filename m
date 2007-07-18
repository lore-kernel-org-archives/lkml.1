Return-Path: <linux-kernel-owner+w=401wt.eu-S935458AbXGRWnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935458AbXGRWnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761272AbXGRWn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:43:27 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:37320 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761031AbXGRWn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aalO8Img8t6IfJd8Z4WM9eToRA33gGx3Sl9Y2CHAfqwo2LrJVipWQ0dmDGC/Skvi1B5zSrFEOdQWrarUbyZFNFDGoL2TSooFk+P0Jzyp9Go9R2DxJAcMl/HdvVpfKeLet1J6PFrMWR+uo70BR879j1/eI7mEbvFmQHklA+kc/Oo=
Subject: Re: VESAFB CUSTOM RESOLUTION
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Matan Ziv-Av <matan@svgalib.org>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707181946390.7311@matan.home>
References: <200707181342.00647.a1426z@gawab.com>
	 <1184760917.4523.13.camel@daplas>
	 <Pine.LNX.4.64.0707181946390.7311@matan.home>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 06:43:18 +0800
Message-Id: <1184798598.4523.75.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 19:59 +0300, Matan Ziv-Av wrote:
> On Wed, 18 Jul 2007, Antonino A. Daplas wrote:
> 
> > So, one cannot just set any mode, unless that mode is already defined in
> > the BIOS mode table. In VBE 3.0, you might be able to choose an
> > arbitrary vertical refresh rate, but that's the best mode tuning you can
> > do with the video BIOS.
> 
> Theoretically, not correct. VBE 3.0 allows arbitrary mode setting - not 
> only vertical refresh, but all mode parameters (the ones appearing in X 
> modelines). This is supported by both svgalib and uvesafb. I don't know 
> on how many VBE3 cards this feature really works, but it does work for 
> some cards.

The CRTCInfoBlock structure passed for Function 0x4f02 does not include
xres and yres so the horizontal and vertical active lengths cannot be
modified arbitrarily, an appropriate mode ID must still be chosen. I
cannot set 880x244, for example, if it's not in the table. It's the
horizontal timings, the vertical timings and the pixelclock that can be
adjusted.

Tony

