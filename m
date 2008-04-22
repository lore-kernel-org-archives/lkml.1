Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbYDVO56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbYDVO56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYDVO5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:57:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59092 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYDVO5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:57:50 -0400
Subject: Re: [2.6 patch] mtd: make onenand_scan_bbt() static
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080414142036.GU6695@cs181133002.pp.htv.fi>
References: <20080414142036.GU6695@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 15:57:46 +0100
Message-Id: <1208876266.9212.606.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 17:20 +0300, Adrian Bunk wrote:
> This patch makes the needlessly global onenand_scan_bbt() static.

Nak. It's not unlikely that a board driver will need this. It just
introduces a gratuitous difference between NAND and OneNAND.

-- 
dwmw2

