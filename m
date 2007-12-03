Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbXLCQgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbXLCQgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXLCQg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:36:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54007 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbXLCQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:36:29 -0500
Date: Mon, 3 Dec 2007 17:36:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203163626.GC4004@one.firstfloor.org>
References: <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202144331.6abf1289@laptopd505.fenrus.org> <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org> <20071203102715.GC28560@one.firstfloor.org> <20071203072328.371d0b00@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203072328.371d0b00@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the scsi layer will have the IO totally aborted within that time anyway;
> the retry timeout for disks is 30 seconds after all.

There are blocking waits who wait for multiple IOs. 

Also i think the SCSI driver can tune this anyways and I suspect
iSCSI and friends increase it (?)

-Andi

