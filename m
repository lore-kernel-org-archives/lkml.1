Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbXFIOxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbXFIOxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 10:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXFIOxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 10:53:38 -0400
Received: from aun.it.uu.se ([130.238.12.36]:56500 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXFIOxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 10:53:38 -0400
Date: Sat, 9 Jun 2007 16:53:32 +0200 (MEST)
Message-Id: <200706091453.l59ErWtB026333@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: ghpille@hotmail.com, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: system clock slow on Athlon AMD64 since 2.6.21
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2007 10:14:03 +0200, Gerard H. Pille wrote:
> [1.] One line summary of the problem:
> Since I switched from 2.6.20 to 2.6.21 on my Athlon AMD64 laptop, the system 
> time is slow - about 1' on 15'.

According to your system description it seems that you have a
Targa Visionary laptop with a VIA chipset and a Mobile Athlon64.
If so, then you probably have the same problem I reported some time
ago: see <http://marc.info/?l=linux-kernel&m=117681226421346&w=2>
and the followup messages. The conclusion was that the chipset's
ACPI PM timer slows down when the CPU is in C2.

The workaround is to boot with processor.max_cstate=1.

/Mikael
