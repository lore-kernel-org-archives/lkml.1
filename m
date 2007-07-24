Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbXGXQxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbXGXQxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbXGXQxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:53:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55026 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbXGXQxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:53:37 -0400
Date: Tue, 24 Jul 2007 18:53:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
cc: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
In-Reply-To: <46A53B70.1010903@intel.com>
Message-ID: <Pine.LNX.4.64.0707241852510.18990@fbirervta.pbzchgretzou.qr>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A53B70.1010903@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 23 2007 16:36, Kok, Auke wrote:
>
> this somehow seems to match something completely non-related (a function
> pointer declaration case):
>
> ERROR: no space between function name and open parenthesis '('
> #7278: FILE: drivers/net/e1000e/hw.h:434:
> +       bool (*check_mng_mode)(struct e1000_hw *);
>
> even if I put a space between ")(", it still complains.

[assumed] majority of kernel code uses ")(" instead of ")\s+(",
so the warning seems bogus. And it even gets nitpicky.



	Jan
-- 
