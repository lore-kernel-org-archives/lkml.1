Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbZCFQb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbZCFQb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZCFQbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:31:13 -0500
Received: from usea-naimss3.unisys.com ([192.61.61.105]:3583 "EHLO
	usea-naimss3.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZCFQbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:31:12 -0500
Subject: Re: [PATCH] MSI: check for BIOS assigned addresses
From: Daniel Yeisley <dan.yeisley@unisys.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20090306162402.GA8936@elte.hu>
References: <1236352309.31604.2.camel@localhost.localdomain>
	 <20090306162402.GA8936@elte.hu>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 10:56:49 -0500
Message-Id: <1236355009.31604.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 (2.25.92-1.fc11) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2009 16:26:57.0371 (UTC) FILETIME=[5E64FAB0:01C99E78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI hotplug doesn't work.

Dan


On Fri, 2009-03-06 at 17:24 +0100, Ingo Molnar wrote:
> * Daniel Yeisley <dan.yeisley@unisys.com> wrote:
> 
> > When creating MSI addresses the kernel makes them up and 
> > writes them to the hardware without first checking for what 
> > the system BIOS may have assigned.  The patch below checks for 
> > already assigned values, and leaves them alone if they exist.
> > 
> > Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>
> 
> What happens without this fix - do you get non-working cards? 
> Boot hang? Or a suboptimal layout?
> 
> 	Ingo

