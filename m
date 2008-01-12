Return-Path: <linux-kernel-owner+w=401wt.eu-S1763449AbYALUX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763449AbYALUX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932105AbYALUVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:21:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33251 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762610AbYALUVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:21:51 -0500
Date: Sat, 12 Jan 2008 20:21:47 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: akpm@osdl.org, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: remove "too much work for irq" printk
Message-ID: <20080112202147.GA2730@infradead.org>
References: <20080112201543.GB12775@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112201543.GB12775@kvack.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 03:15:43PM -0500, Benjamin LaHaise wrote:
> When using kvm with a serial console, the serial driver will print out 
> "too much work for irq4" on any heavy activity (ie vi on a file repainting 
> the terminal).  This message is entirely spurious, as output continues to 
> work fine.  Remove the message as it corrupts screen output and is far too 
> easy to trigger.

Yeah, this message has been annoying me too.  Thanks for sending the
patch.

