Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbZEFK7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbZEFK7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 06:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZEFK7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 06:59:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40248 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZEFK7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 06:59:01 -0400
Date: Wed, 6 May 2009 12:58:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: cbe-oss-dev@ozlabs.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH, RFC] sputrace: use the generic event tracer
Message-ID: <20090506105842.GF25203@elte.hu>
References: <20090506102918.GA23278@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506102918.GA23278@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@lst.de> wrote:

> Index: linux-2.6-tip/arch/powerpc/platforms/cell/spufs/sputrace.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/powerpc/platforms/cell/spufs/sputrace.c	2009-05-06 10:18:03.000000000 +0000
> +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> @@ -1,272 +0,0 @@
> -/*
> - * Copyright (C) 2007 IBM Deutschland Entwicklung GmbH
> - *	Released under GPL v2.
> - *
> - * Partially based on net/ipv4/tcp_probe.c.

btw., net/ipv4/tcp_probe.c would be another potential candidate to 
convert to tracepoints.

	Ingo
