Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbXJ2VtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbXJ2VtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXJ2VtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:49:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37333 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbXJ2VtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:49:01 -0400
Date: Mon, 29 Oct 2007 22:48:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [bug, 2.6.24-rc1] sysfs: duplicate filename 'eth0' can not be
	created
Message-ID: <20071029214850.GA31152@elte.hu>
References: <20071029211746.GA19876@elte.hu> <20071029144016.06c03b7c@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029144016.06c03b7c@freepuppy.rosehill>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Hemminger <shemminger@linux-foundation.org> wrote:

> Already fixed post 2.6.24-rc1
> 
> commit c8d90dca3211966ba5189e0f3d4bccd558d9ae08
> Author: Stephen Hemminger <shemminger@linux-foundation.org>
> Date:   Fri Oct 26 03:53:42 2007 -0700
> 
>     [NET] dev_change_name: ignore changes to same name

ah, nice - that explains it. I just booted with very latest -git and the 
warning is gone.

	Ingo
