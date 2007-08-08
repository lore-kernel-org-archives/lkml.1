Return-Path: <linux-kernel-owner+w=401wt.eu-S938306AbXHHVk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938306AbXHHVk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934707AbXHHVks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:40:48 -0400
Received: from khc.piap.pl ([195.187.100.11]:35238 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763820AbXHHVkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:40:47 -0400
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 55] drivers/char/n_hdlc.c: kmalloc + memset conversion to kzalloc
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707312327.30692.m.kozlowski@tuxland.pl>
	<20070801011655.08e3c17b@the-village.bc.nu>
	<200708080802.24635.m.kozlowski@tuxland.pl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 08 Aug 2007 23:40:44 +0200
In-Reply-To: <200708080802.24635.m.kozlowski@tuxland.pl> (Mariusz Kozlowski's message of "Wed, 8 Aug 2007 08:02:24 +0200")
Message-ID: <m3d4xx66xv.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski <m.kozlowski@tuxland.pl> writes:

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
>
>  drivers/char/n_hdlc.c | 27451 -> 27413 (-38 bytes)
>  drivers/char/n_hdlc.o | 107068 -> 107088 (+20 bytes)

BTW: drivers/char/n_hdlc is a very different thing than these
in drivers/net/wan/ and I have no connection with it. Not sure
who is responsible, if anyone.
-- 
Krzysztof Halasa
