Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbYHaRaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbYHaRaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbYHaRaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:30:25 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:64663 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbYHaRaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:30:24 -0400
Date: Mon, 01 Sep 2008 02:30:26 +0900 (JST)
Message-Id: <20080901.023026.55145642.anemo@mba.ocn.ne.jp>
To: alan@lxorguk.ukuu.org.uk
Cc: david@fries.net, linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] ne.c msleep not mdelay
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080830154447.770aaca0@lxorguk.ukuu.org.uk>
References: <20080830095906.6cad8647@lxorguk.ukuu.org.uk>
	<20080830.233647.05599714.anemo@mba.ocn.ne.jp>
	<20080830154447.770aaca0@lxorguk.ukuu.org.uk>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008 15:44:47 +0100, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > So, if rescheduling was dangerous here, we already have potential
> > problems, no?
> 
> Yes we do but I didn't manage to stop the other mistakes getting in when
> they did. If you take a schedule you get results back from the probe_irq
> that tend to suck in other random ISA device events (ISA being edge
> triggered nobody was ever careful about spurious irq)

OK, I see your point.  Thanks.

---
Atsushi Nemoto
