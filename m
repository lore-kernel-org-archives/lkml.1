Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYH3PPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYH3PPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 11:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYH3PPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 11:15:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44447 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751988AbYH3PPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 11:15:38 -0400
Date: Sat, 30 Aug 2008 15:58:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Fries <david@fries.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       p_gortmaker@yahoo.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] ne.c msleep not mdelay
Message-ID: <20080830155826.06743636@lxorguk.ukuu.org.uk>
In-Reply-To: <20080830145746.GG25161@spacedout.fries.net>
References: <20080830024453.GB24929@spacedout.fries.net>
	<20080830095906.6cad8647@lxorguk.ukuu.org.uk>
	<20080830.233647.05599714.anemo@mba.ocn.ne.jp>
	<20080830145746.GG25161@spacedout.fries.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I was just going to make the argument that any task that could be run
> during msleep, could just as easily run on the other cpu in mdelay (if
> there was one).

ISA bus auto-probing doesn't actually work at all well on SMP. The number
of people who have ever been affected by that has always been effectively
nil.

