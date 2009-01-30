Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZA3F02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZA3F02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 00:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbZA3F0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 00:26:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39938 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbZA3F0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 00:26:19 -0500
Message-ID: <49828F4E.40208@zytor.com>
Date: Thu, 29 Jan 2009 21:25:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Jonathan Campbell <jon@nerdgrounds.com>,
       "Peter W. Morreale" <pmorreale@novell.com>, devel@driverdev.osuosl.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
References: <497E4531.20800@nerdgrounds.com> <497E4919.60907@zytor.com> <497E4C5E.2030201@nerdgrounds.com> <1233248649.7191.130.camel@hermosa.site> <4981E7BD.3040507@nerdgrounds.com> <4981E99F.30001@zytor.com> <498271DF.6090406@nerdgrounds.com> <4982860E.2060605@zytor.com> <20090130052007.GM5038@1wt.eu>
In-Reply-To: <20090130052007.GM5038@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> 
> Also, MTD allows you to map *part* of the VRAM. On my laptop, I only
> map 56 MB out of the 64 MB of VRAM, which still allows me to use the
> VGA normally. And BTW, I map this VRAM as a fast swap memory.
> 
> In fact, I see little use to the VRAMFS for the average user. Still
> it might have been a nice coding exercice for Jonathan.
> 

Also, the idea of using the DMA engine on the video card rather than
just doing PIO references is an excellent one.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

