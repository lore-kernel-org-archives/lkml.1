Return-Path: <linux-kernel-owner+w=401wt.eu-S1764280AbXGRWuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764280AbXGRWuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbXGRWuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:50:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42096 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbXGRWuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:50:21 -0400
Message-ID: <469E9918.8040907@zytor.com>
Date: Wed, 18 Jul 2007 15:50:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Jan Engelhardt <jengelh@computergmbh.de>, Bodo Eggert <7eggert@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <Pine.LNX.4.64.0707072312380.1536@fbirervta.pbzchgretzou.qr> <469002EB.7030902@zytor.com> <200707181751.10276.rob@landley.net>
In-Reply-To: <200707181751.10276.rob@landley.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> 
> Out of curiosity, do you know which setup?  I know that it won't actually swap 
> anything out yet because no swap is mounted, but I thought that mounting 
> tmpfs and doing a swapon afterwards was ok...
> 

Nope, I just know that the "obvious" way to do it crashes the kernel
horribly.  It looks based on the patchsets that have flown about
recently as it's mostly a matter of initializing the icache.

	-hpa
