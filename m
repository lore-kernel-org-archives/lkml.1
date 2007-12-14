Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbXLNSMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbXLNSMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXLNSMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:12:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34052 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbXLNSMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:12:18 -0500
Date: Fri, 14 Dec 2007 19:12:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071214181233.GB16351@one.firstfloor.org>
References: <20071214004442.5f9eba88@linux360.ro> <p737ijigr8c.fsf@bingen.suse.de> <20071214143941.2c7dcfb4@linux360.ro> <20071214101720.GA10981@one.firstfloor.org> <20071214154106.4f0b2d8c@linux360.ro> <20071214122048.GA12550@one.firstfloor.org> <20071214180119.4c492f6c@linux360.ro> <alpine.LFD.0.99999.0712141835510.3668@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.99999.0712141835510.3668@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> magically in the SMM code. To work around this is we would need to add
> the broadcast notification to the halt(), safe_halt(), pm_idle_halt()
> variants which float around in the kernel and make this conditional on
> the C1E detection. That's nasty, but it seems the only solution for
> now.

On 64bit it would be easy using the idle notifiers. Perhaps they need
to be extended to pass in the sleep state though.
 
-Andi
