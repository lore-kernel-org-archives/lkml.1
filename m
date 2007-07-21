Return-Path: <linux-kernel-owner+w=401wt.eu-S1764918AbXGUMEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764918AbXGUMEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 08:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbXGUMEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 08:04:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:45497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466AbXGUMEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 08:04:37 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] [9/11] x86: Replace NSC/Cyrix specific chipset access macros by inlined functions.
Date: Sat, 21 Jul 2007 14:04:32 +0200
User-Agent: KMail/1.9.6
Cc: juergen@kreuzholzen.de, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070720532.949522000@suse.de> <20070720153253.D17F214E7B@wotan.suse.de> <20070721120001.GA5832@martell.zuzino.mipt.ru>
In-Reply-To: <20070721120001.GA5832@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707211404.32877.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Why bother with new header, just make static inline in asm/processor.h.

processor.h is already far too big, some splitting up is a good thing.

-Andi
