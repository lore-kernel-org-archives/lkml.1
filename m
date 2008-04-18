Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYDRNXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYDRNXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbYDRNWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:22:55 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:21722 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbYDRNWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:22:55 -0400
Date: Fri, 18 Apr 2008 15:22:52 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: simplify hex print
Message-ID: <20080418132252.GA9275@osiris.boeblingen.de.ibm.com>
References: <alpine.LFD.1.10.0804181430310.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804181430310.3261@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 02:33:20PM +0200, Thomas Gleixner wrote:
> simplify hex to ascii conversion with a lookup table.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> +static const char hex2asc[] = "0123456789abcdef";
[...]
> +		hex[j++] = hex2asc[byte & 0x0f];
> +		hex[j++] = hex2asc[byte >> 4];

we have hex_asc() in include/linux/kernel.h already.
