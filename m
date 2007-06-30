Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbXF3Pmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbXF3Pmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 11:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXF3Pmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 11:42:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45205 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbXF3Pml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 11:42:41 -0400
Subject: Re: IRQ handling difference between i386 and x86_64
From: Arjan van de Ven <arjan@infradead.org>
To: Krzysztof Oledzki <olel@ans.pl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706301617240.16011@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0706301617240.16011@bizon.gios.gov.pl>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 30 Jun 2007 08:40:35 -0700
Message-Id: <1183218035.2894.13.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-30 at 16:55 +0200, Krzysztof Oledzki wrote:
> Hello,
> 
> It seems that IRQ handling is somehow different between i386 and x86_64.
> 
> In my Dell PowerEdge 1950 is it possible to enable interrupts spreading 
> over all CPUs. This a single CPU, four CORE system (Quad-Core E5335 Xeon) 
> so I think that interrupts migration may be useful. Unfortunately, it 
> works only with 32-bit kernel. Booting it with x86_64 leads to situation, 
> when all interrupts goes only to the first cpu matching a smp_affinity 
> mask.

arguably that is the most efficient behavior... round robin of
interrupts is the worst possible case in terms of performance

are you using irqbalance ? (www.irqbalance.org)


