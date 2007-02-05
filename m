Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXBEUO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXBEUO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933122AbXBEUO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:14:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:49707 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127AbXBEUOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:14:55 -0500
Subject: Re: [PATCH] Missing include in include/asm-powerpc/prom.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       paulus@samba.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20070205142905.GA31392@Krystal>
References: <20070205142905.GA31392@Krystal>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 07:14:29 +1100
Message-Id: <1170706469.2620.124.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 09:29 -0500, Mathieu Desnoyers wrote:
> Missing include in include/asm-powerpc/prom.h
> 
> include/asm-powerpc/prom.h needs to include asm/irq.h because it uses
> irq_of_parse_and_map and NO_IRQ. It applies on 2.6.20.

I'd rather not do that.... better to move of_irq_to_resource() to
prom_parse.c 

Ben


