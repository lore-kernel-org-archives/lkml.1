Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbXGINOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbXGINOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXGINN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:13:57 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:37538 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbXGINN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:13:56 -0400
Date: Mon, 9 Jul 2007 14:06:06 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] include/asm-mips/processor.h: "extern inline" ->
	"static inline"
Message-ID: <20070709130605.GA5467@linux-mips.org>
References: <20070707010330.GY3492@stusta.de> <20070709102754.GB24487@linux-mips.org> <20070709122240.GY3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709122240.GY3492@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 02:22:40PM +0200, Adrian Bunk wrote:

> In C99 (and therefore in gcc >= 4.3), "extern inline" means that the 
> function should be compiled inline where the inline definition is seen, 
> and that the compiler should also emit a copy of the function body with 
> an externally visible symbol.

Uh, indeed.  Thanks for the reminder.  Patch applied.

  Ralf
