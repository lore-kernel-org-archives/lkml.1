Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZDELhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZDELhF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 07:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZDELgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 07:36:50 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47762 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZDELgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 07:36:49 -0400
Date: Sun, 5 Apr 2009 13:36:46 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: David Miller <davem@davemloft.net>, graham@gmurray.org.uk,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: Regression caused by commit "netfilter: iptables: lock free
 counters"
In-Reply-To: <49D88162.5040809@cosmosbay.com>
Message-ID: <alpine.LSU.2.00.0904051328030.7501@fbirervta.pbzchgretzou.qr>
References: <20090329234702.4988017f@desktop.r000n.info> <8763hja8cy.fsf@newton.gmurray.org.uk> <20090405.012237.198610462.davem@davemloft.net> <49D88162.5040809@cosmosbay.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2009-04-05 12:01, Eric Dumazet wrote:
>
>This could probably be solved using a single "table" containing
>rules only, that could be shared for every cpus. Only counters
>should be percpu. This should save a lot of ram, over previous
>situation (2.6.29 or current one)

Why would counters stay separate?

I recognize all of this table copying is related to do NUMA
optimizations, and I think I heard cache bouncing too somewhere else.

[ http://marc.info/?l=netfilter-devel&m=119903624211253&w=2 ]
