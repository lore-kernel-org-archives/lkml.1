Return-Path: <linux-kernel-owner+w=401wt.eu-S933725AbXLNTxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725AbXLNTxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbXLNTxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:53:34 -0500
Received: from www.tglx.de ([62.245.132.106]:42429 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590AbXLNTxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:53:33 -0500
Date: Fri, 14 Dec 2007 20:53:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
In-Reply-To: <20071214181022.GA16351@one.firstfloor.org>
Message-ID: <alpine.LFD.0.99999.0712142051220.3668@localhost.localdomain>
References: <20071214004442.5f9eba88@linux360.ro> <p737ijigr8c.fsf@bingen.suse.de> <20071214143941.2c7dcfb4@linux360.ro> <20071214101720.GA10981@one.firstfloor.org> <20071214154106.4f0b2d8c@linux360.ro> <20071214122048.GA12550@one.firstfloor.org>
 <20071214180119.4c492f6c@linux360.ro> <20071214181022.GA16351@one.firstfloor.org>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Andi Kleen wrote:

> > LAPIC is seemingly disabled (C1E detection code does this), but
> 
> It should only disable the LAPIC timer, but not the full use of the
> LAPIC. 

That's what it does. The LAPIC timer is invalidated and registered as
a per CPU broadcast dummy source (CLOCK_EVT_FEAT_DUMMY).

Thanks,

	tglx
