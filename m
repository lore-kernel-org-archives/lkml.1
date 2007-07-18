Return-Path: <linux-kernel-owner+w=401wt.eu-S1764145AbXGRRQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764145AbXGRRQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761411AbXGRRPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:15:55 -0400
Received: from indigo.cs.bgu.ac.il ([132.72.42.23]:44507 "EHLO
	indigo.cs.bgu.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758692AbXGRRPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:15:54 -0400
X-Greylist: delayed 942 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2007 13:15:54 EDT
Date: Wed, 18 Jul 2007 19:59:47 +0300 (IDT)
From: Matan Ziv-Av <matan@svgalib.org>
X-X-Sender: matan@matan.home
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: VESAFB CUSTOM RESOLUTION
In-Reply-To: <1184760917.4523.13.camel@daplas>
Message-ID: <Pine.LNX.4.64.0707181946390.7311@matan.home>
References: <200707181342.00647.a1426z@gawab.com> <1184760917.4523.13.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Antonino A. Daplas wrote:

> So, one cannot just set any mode, unless that mode is already defined in
> the BIOS mode table. In VBE 3.0, you might be able to choose an
> arbitrary vertical refresh rate, but that's the best mode tuning you can
> do with the video BIOS.

Theoretically, not correct. VBE 3.0 allows arbitrary mode setting - not 
only vertical refresh, but all mode parameters (the ones appearing in X 
modelines). This is supported by both svgalib and uvesafb. I don't know 
on how many VBE3 cards this feature really works, but it does work for 
some cards.




-- 
Matan Ziv-Av.                         matan@svgalib.org

