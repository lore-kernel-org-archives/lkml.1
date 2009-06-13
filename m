Return-Path: <linux-kernel-owner+w=401wt.eu-S1763069AbZFMP1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763069AbZFMP1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 11:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZFMP1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 11:27:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47795 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752338AbZFMP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 11:27:39 -0400
Date: Sat, 13 Jun 2009 16:28:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Cloos <cloos@jhcloos.com>
Cc: linux-kernel@vger.kernel.org, "Linux-MIPS" <linux-mips@linux-mips.org>,
       Florian Fainelli <florian@openwrt.org>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/8] add lib/gcd.c
Message-ID: <20090613162802.6c212505@lxorguk.ukuu.org.uk>
In-Reply-To: <m38wjwz5ur.fsf@lugabout.jhcloos.org>
References: <200906041615.10467.florian@openwrt.org>
	<m38wjwz5ur.fsf@lugabout.jhcloos.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Would the binary gcd algorithm not be a better fit for the kernel?
> 
> It avoids division, using only shifts and subtraction:

Time them both and see. I suspect on a lot of processors the divide based
one now wins. We also have fls() and ffs() which may mean some platforms
can implement the first two loops even better.

Could well be the shift based one is better for some processors only.
