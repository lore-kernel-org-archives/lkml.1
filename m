Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbYHAWwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbYHAWwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYHAWwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:52:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36389 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYHAWwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:52:24 -0400
Date: Sat, 2 Aug 2008 00:52:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Jack Steiner <steiner@sgi.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: bounds check IRQ to prevent memory corruption
Message-ID: <20080801225236.GA15372@one.firstfloor.org>
References: <20080801215755.4761.92512.stgit@tigger.helgaas>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801215755.4761.92512.stgit@tigger.helgaas>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 03:58:17PM -0600, Bjorn Helgaas wrote:
> 
> acpi_penalize_isa_irq() should validate irq before using it to
> index the acpi_irq_penalty[] table.

Applied to test thanks.

> I think this should go in 2.6.27.

Agreed.

-Andi
