Return-Path: <linux-kernel-owner+w=401wt.eu-S965050AbXBTP2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050AbXBTP2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965066AbXBTP2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:28:33 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2772 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965052AbXBTP2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:28:32 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
Date: Tue, 20 Feb 2007 16:29:40 +0100
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702201629.40758.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

Please fix the parentheses thing in both arch/powerpc/mm/pgtable_32.c and 
arch/ppc/mm/pgtable.c.

> +#define is_power_of_4(x)	is_power_of_2(x) && (ffs(x) & 1))

Regards,

	Mariusz Kozlowski
