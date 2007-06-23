Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbXFWSBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbXFWSBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 14:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbXFWSBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 14:01:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:2001 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbXFWSBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 14:01:30 -0400
Date: Sat, 23 Jun 2007 20:01:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexander Wuerstlein <snalwuer@cip.informatik.uni-erlangen.de>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       arw@arw.name
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
In-Reply-To: <20070621174612.GG9741@cip.informatik.uni-erlangen.de>
Message-ID: <Pine.LNX.4.64.0706232001070.11964@fbirervta.pbzchgretzou.qr>
References: <11824417551424-git-send-email-arw@arw.name>
 <1182446251.2704.0.camel@laptopd505.fenrus.org>
 <20070621172557.GE9741@cip.informatik.uni-erlangen.de>
 <1182446983.2704.4.camel@laptopd505.fenrus.org>
 <20070621174612.GG9741@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 21 2007 19:46, Alexander Wuerstlein wrote:
>
>If a process uses read() it needs some executable and writable memory. We do
>check for this in mprotect(). There is a problem with the i386-architecture,
>because it allows execution of any readable page (except with newer
>processors). But beyond that ugliness of i386, it should not be possible to
>execute anything without us noticing it (hopefully).

r and x together is not a problem IMHO.


	Jan
-- 
