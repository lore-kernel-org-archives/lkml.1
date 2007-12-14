Return-Path: <linux-kernel-owner+w=401wt.eu-S933164AbXLNMUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbXLNMUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 07:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbXLNMUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 07:20:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52276 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbXLNMUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 07:20:35 -0500
Date: Fri, 14 Dec 2007 13:20:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071214122048.GA12550@one.firstfloor.org>
References: <20071214004442.5f9eba88@linux360.ro> <p737ijigr8c.fsf@bingen.suse.de> <20071214143941.2c7dcfb4@linux360.ro> <20071214101720.GA10981@one.firstfloor.org> <20071214154106.4f0b2d8c@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214154106.4f0b2d8c@linux360.ro>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 03:41:06PM +0200, Eduard-Gabriel Munteanu wrote:
> On Fri, 14 Dec 2007 11:17:21 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > >so do whatever is necessary to enable dynticks. 
> > 
> > dynticks' main purpose is to save power, but C1e saves more power.
> > Disabling C1e for dynticks would be a fairly useless default
> > trade off.
> 
> I see. Also, AMD specs say that either higher C-states are enabled, or
> C1E, but not both at the same time. So if the BIOS doesn't offer an

AMD doesn't support states deeper than C1 on multi core currently, so 
in general they don't matter much right now.

> Dynticks also provides lower latencies as far as I know. 

The better solution there is to use HPET instead. Newer systems
generally have HPET already enabled in the BIOS and for older systems
hpet=force gains more and more support. So try that.

-Andi
