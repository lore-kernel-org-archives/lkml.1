Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYFIQXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYFIQXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYFIQXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:23:08 -0400
Received: from mx1.suse.de ([195.135.220.2]:32781 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYFIQXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:23:06 -0400
Date: Mon, 9 Jun 2008 18:23:41 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Johannes Weiner <hannes@saeurebad.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, anderson@redhat.com, andi@firstfloor.org
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
Message-ID: <20080609182341.00d6e746@halley.suse.de>
In-Reply-To: <20080609132207.GC3542@redhat.com>
References: <20080608134628.757299158@halley.suse.de>
	<20080608134629.743220278@halley.suse.de>
	<87bq2bmvro.fsf@saeurebad.de>
	<20080609132207.GC3542@redhat.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal [2008-06-09 09:22]:
>
> Kdump first kernel always tries to reserve just physical RAM and nothing
> else. So I am not sure what does above code do. Try to reserve a memory
> which is not RAM but is in the region less than highest mapped entity and
> in that case return silently without any warning. In what case do we
> exercise this path?

I don't know. That code has been introduced in 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5e58a02a8f6a7a1c9ae41f39286bcd3aea0d6f24

Ccing Andi.

IMO we should not print any warning in that function, leaving the error
handling to the caller.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Maintenance
