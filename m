Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbXBPQah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbXBPQah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932483AbXBPQah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:30:37 -0500
Received: from mother.pmc-sierra.com ([216.241.224.12]:46648 "HELO
	mother.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932438AbXBPQag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:30:36 -0500
Message-ID: <45D5DC24.7090506@pmc-sierra.com>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marc St-Jean <stjeanma@pmc-sierra.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
	er
Date: Fri, 16 Feb 2007 08:30:28 -0800
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 16 Feb 2007 16:30:28.0716 (UTC) FILETIME=[C4F6EAC0:01C751E7]
user-agent: Thunderbird 1.5.0.9 (X11/20061206)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 13:26:29 -0600
> Marc St-Jean <stjeanma@pmc-sierra.com> wrote:
> 
>  > +                     status = *(volatile u32 *)up->port.private_data;
> 
> It distresses me that this patch uses a variable which this patch
> doesn't initialise anywhere.  It isn't complete.
> 
> The sub-driver code whch sets up this field shuld be included in the
> patch, no?
> 

OK, I'll re-post with the platform file which initializes the variable.
That file however will reference other files in the platform which has
not been posted yet. I thought it was better to post the driver-only code.

Marc
