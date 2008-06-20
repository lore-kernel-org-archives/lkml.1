Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbYFTRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbYFTRwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYFTRwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:52:09 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:52610 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbYFTRwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:52:08 -0400
Date: Sat, 21 Jun 2008 02:53:34 +0900 (JST)
Message-Id: <20080621.025334.25909435.anemo@mba.ocn.ne.jp>
To: sr@denx.de
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] jedec_probe: Fix SST 16-bit chip detection
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <200806200708.37974.sr@denx.de>
References: <20080619.163648.262833678.nemoto@toshiba-tops.co.jp>
	<1213896113.26255.1434.camel@pmac.infradead.org>
	<200806200708.37974.sr@denx.de>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 07:08:37 +0200, Stefan Roese <sr@denx.de> wrote:
> > I believe you about the uaddr -- but can these devices really not be
> > used in 8-bit mode?
> 
> No. They are 16-bit only.

Right.  They do not have BYTE# pin, according to their datasheets:

http://www.sst.com/downloads/datasheet/S71145.pdf
http://www.sst.com/downloads/datasheet/S71223.pdf

---
Atsushi Nemoto
