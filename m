Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab0BCQqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:46:48 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:64525 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab0BCQqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:46:45 -0500
MIME-Version: 1.0
In-Reply-To: <e46b06510f7eb6ca51ea8b96335b2d32ec8bf6f8.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173246.git.amit.kucheria@verdurent.com> 
	<0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com> 
	<9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com> 
	<ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com> 
	<ec63e5978fd5ac5d308ede5916e648ba925818eb.1265173480.git.amit.kucheria@canonical.com> 
	<f10f79e7313ecdeeb59ab881795baedf2430c636.1265173480.git.amit.kucheria@canonical.com> 
	<240f12ca87d7666f31263aabc620a9ec197cd8ff.1265173480.git.amit.kucheria@canonical.com> 
	<cover.1265173480.git.amit.kucheria@canonical.com> <752ae69adb57d4f73fa011ba380cea1b927b9c8b.1265173480.git.amit.kucheria@canonical.com> 
	<e46b06510f7eb6ca51ea8b96335b2d32ec8bf6f8.1265173480.git.amit.kucheria@canonical.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 3 Feb 2010 09:46:24 -0700
X-Google-Sender-Auth: d788f5c8987d6291
Message-ID: <fa686aa41002030846v5044d585w7f4291f89c4b7ad@mail.gmail.com>
Subject: Re: [PATCHv2 08/11] fec: fix uninitialized rx buffer usage
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Rob Herring <r.herring@freescale.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       Dinh.Nguyen@freescale.com, bryan.wu@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 10:16 PM, Amit Kucheria
<amit.kucheria@canonical.com> wrote:
> From: Rob Herring <r.herring@freescale.com>
>
> The fec driver was enabling receive buffer descriptor without allocating
> the buffers. Make sure the buffer descriptors are initialized to not
> start receiving packets.
>
> Open also calls fec_restart after the rx buffers are allocated. With the code
> in fec_restart, it zeroes out the buffer descriptors that have just been
> setup.

fec related patches 8 & 9 look okay to me.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
