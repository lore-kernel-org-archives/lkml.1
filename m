Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbXLLLO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbXLLLO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXLLLOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:14:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48302 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbXLLLOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:14:17 -0500
Date: Wed, 12 Dec 2007 03:14:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH 06/47] Add serial driver for CRISv32.
Message-Id: <20071212031411.e8b00037.akpm@linux-foundation.org>
In-Reply-To: <198a9a1fad3830f89aa033f38c7600ec512d1947.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
	<198a9a1fad3830f89aa033f38c7600ec512d1947.1196848533.git.jesper.nilsson@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 17:23:14 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> +static void serial_cris_set_mctrl(struct uart_port *port, unsigned int mctrl)
> +{
> +	struct uart_cris_port *up = (struct uart_cris_port *)port;

use container_of() here

> +static irqreturn_t dma_tr_interrupt(int irq, void *dev_id)
> +{
> +	struct uart_cris_port *up = (struct uart_cris_port *)dev_id;

This driver is a somewhat depressing read too.
