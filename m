Return-Path: <linux-kernel-owner+w=401wt.eu-S1765461AbXLNKpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765461AbXLNKpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbXLNKom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:44:42 -0500
Received: from [194.117.236.238] ([194.117.236.238]:45845 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbXLNKol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:44:41 -0500
Date: Fri, 14 Dec 2007 15:41:06 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071214154106.4f0b2d8c@linux360.ro>
In-Reply-To: <20071214101720.GA10981@one.firstfloor.org>
References: <20071214004442.5f9eba88@linux360.ro>
	<p737ijigr8c.fsf@bingen.suse.de>
	<20071214143941.2c7dcfb4@linux360.ro>
	<20071214101720.GA10981@one.firstfloor.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 11:17:21 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> >so do whatever is necessary to enable dynticks. 
> 
> dynticks' main purpose is to save power, but C1e saves more power.
> Disabling C1e for dynticks would be a fairly useless default
> trade off.

I see. Also, AMD specs say that either higher C-states are enabled, or
C1E, but not both at the same time. So if the BIOS doesn't offer an
option to disable C1E, it can't provide _CST or P_LVL* ACPI
objects for higher C-states.

Dynticks also provides lower latencies as far as I know. I think this
workaround should be merged, even if as a non-default config option.

I'll resubmit a patch if you agree.

(By the way, sorry for messing up the "Cc:" fields in the previous
message.)
