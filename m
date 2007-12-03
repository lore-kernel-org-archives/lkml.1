Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbXLCPZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbXLCPZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbXLCPZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:25:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56032 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXLCPZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:25:28 -0500
Date: Mon, 3 Dec 2007 07:23:28 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203072328.371d0b00@laptopd505.fenrus.org>
In-Reply-To: <20071203102715.GC28560@one.firstfloor.org>
References: <20071202185945.GA25990@elte.hu>
	<20071202114152.3bf4332d@laptopd505.fenrus.org>
	<20071202200953.GA23994@one.firstfloor.org>
	<20071202202602.GA16480@elte.hu>
	<20071202204725.GA25891@one.firstfloor.org>
	<20071202144331.6abf1289@laptopd505.fenrus.org>
	<20071203000741.GB26636@one.firstfloor.org>
	<20071202165913.3eaebee6@laptopd505.fenrus.org>
	<20071203095501.GB28560@one.firstfloor.org>
	<20071203111520.33ed2139@astralstorm.puszkin.org>
	<20071203102715.GC28560@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 11:27:15 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > Kernel waiting 2 minutes on TASK_UNINTERRUPTIBLE is certainly
> > broken.
> 
> What should it do when the NFS server doesn't answer anymore or 
> when the network to the SAN RAID array located a few hundred KM away
> develops some hickup?  Or just the SCSI driver decides to do lengthy
> error recovery  -- you could argue that is broken if it takes longer 
> than 2 minutes, but in practice these things are hard to test
> and to fix.
> 

the scsi layer will have the IO totally aborted within that time anyway;
the retry timeout for disks is 30 seconds after all.




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
