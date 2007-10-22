Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbXJVPas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbXJVPas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 11:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXJVPal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 11:30:41 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:52767 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbXJVPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 11:30:40 -0400
Date: Mon, 22 Oct 2007 16:29:12 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@osdl.org, akpm@osdl.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Message-ID: <20071022152912.GA841@linux-mips.org>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru> <20071021005418.GU8181@ftp.linux.org.uk> <20071021093042.GA2144@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021093042.GA2144@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 01:30:42PM +0400, Alexey Dobriyan wrote:

> 			irq_flags_t
> 	
> New type for use with spin_lock_irqsave() and friends.

Talking about it, why did we ever require this to be a long anyway?  I could
get away with a single bit for MIPS; the rest of this variable is pure
bloat.  An abstract datatype could help finally fix this.

  Ralf
