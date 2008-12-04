Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbYLDV6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbYLDV6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 16:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbYLDV6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 16:58:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60656 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbYLDV6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 16:58:11 -0500
Date: Thu, 4 Dec 2008 23:09:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.28-rc6: early panic with boot option "nosmp"
Message-ID: <20081204220919.GU6703@one.firstfloor.org>
References: <20081204022806.GA29293@localhost> <20081204101343.GO6703@one.firstfloor.org> <20081204120214.GA30833@localhost> <20081204123335.GP6703@one.firstfloor.org> <20081204153411.GA18306@elte.hu> <493846E1.7010104@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493846E1.7010104@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> but smp_found_config is set acpi_boot_init.. with madt.
> 
> could move that check earlier

Then it wouldn't print the "Using ACPI foo" messages. I think it's better
to put it later like my patch did.

BTW the function could really need splitting up, it seems to do lots
of unrelated things.

-Andi
