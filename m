Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbXLOMli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbXLOMli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 07:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXLOMlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 07:41:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57409 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbXLOMla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 07:41:30 -0500
Date: Sat, 15 Dec 2007 13:41:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071215124147.GA26909@one.firstfloor.org>
References: <20071214004442.5f9eba88@linux360.ro> <p737ijigr8c.fsf@bingen.suse.de> <20071214143941.2c7dcfb4@linux360.ro> <20071214101720.GA10981@one.firstfloor.org> <47630521.4060505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47630521.4060505@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 05:35:13PM -0500, Chuck Ebbert wrote:
> On 12/14/2007 05:17 AM, Andi Kleen wrote:
> >> so do whatever is necessary to enable dynticks. 
> > 
> > dynticks' main purpose is to save power, but C1e saves more power.
> > Disabling C1e for dynticks would be a fairly useless default
> > trade off.
> > 
> 
> What about machines where the BIOS has disabled C1e on CPU 0 but
> left it enabled on CPU 1 ??

It's a BIOS bug.  We handle this and threat it like C1e always enabled.

The right fix would be to enable it on both CPUs, but 
then that's not strictly needed for correct operation and I'm not
sure it would be worth special fixup code in Linux. Probably not.

-Andi
