Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbXJCJ76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbXJCJ76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXJCJ7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:59:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50447 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXJCJ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:59:51 -0400
Subject: Re: [bootup warning] "driver" has no release callback, .23-rc9
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20071003070816.GA1208@elte.hu>
References: <20071003070816.GA1208@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 03 Oct 2007 06:59:44 -0300
Message-Id: <1191405584.28201.31.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Em Qua, 2007-10-03 às 09:08 +0200, Ingo Molnar escreveu:
> FYI, there are 7 V4L drivers that produce this (non-fatal) warning:

Those warnings are inoffensive ;) V4L core does provide a generic
release callback. Anyway, we'll take a look on it and fix, to avoid the
warnings.

> 
> [ 132.060848] videodev: "vivi" has no release callback. Please fix your 
> driver for proper sysfs support, see http://lwn.net/Articles/36850/
> 
> [ 132.124436] videodev: "Aztech radio" has no release callback. Please 
> fix your driver for proper sysfs support, see 
> http://lwn.net/Articles/36850/
> 
> [ 135.685993] videodev: "Typhoon Radio" has no release callback. Please 
> fix your driver for proper sysfs support, see 
> http://lwn.net/Articles/36850/
> 
> [ 135.752619] videodev: "TerraTec ActiveRadio" has no release callback. 
> Please fix your driver for proper sysfs support, see 
> http://lwn.net/Articles/36850/
> 
> [ 135.874244] videodev: "RadioTrack radio" has no release callback. 
> Please fix your driver for proper sysfs support, see 
> http://lwn.net/Articles/36850/
> 
> [ 167.937597] videodev: "Zoltrix Radio Plus" has no release callback. 
> Please fix your driver for proper sysfs support, see 
> http://lwn.net/Articles/36850/
> 
> [ 168.021325] videodev: "GemTek radio" has no release callback. Please 
> fix your driver for proper sysfs support, see 
> http://lwn.net/Articles/36850/
> 
> 	Ingo
-- 
Cheers,
Mauro

