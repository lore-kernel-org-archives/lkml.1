Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbXF2ScL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbXF2ScL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 14:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbXF2Sb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 14:31:57 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:45371 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbXF2Sb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 14:31:56 -0400
Date: Fri, 29 Jun 2007 10:49:26 -0400
From: Kyle McMartin <kyle@parisc-linux.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Andi Kleen <ak@suse.de>,
       Kyle McMartin <kyle@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] generic bug: use show_regs() instead of dump_stack()
Message-ID: <20070629144926.GF9495@fattire.cabal.ca>
References: <20070629121959.GA16581@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629121959.GA16581@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 02:19:59PM +0200, Heiko Carstens wrote:
> -		tt = report_bug(regs->iaoq[0] & ~3);
> +		tt = report_bug(regs->iaoq[0] & ~3, regs);

Groovy, I'll try to test this over the weekend.
