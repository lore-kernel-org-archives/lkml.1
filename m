Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbXLMLOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbXLMLOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 06:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXLMLNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 06:13:51 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:57290 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbXLMLNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 06:13:50 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Thu, 13 Dec 2007 12:11:32 +0100
User-Agent: KMail/1.9.6
Cc: Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com, mbuesch@freenet.de
References: <20071213003028.676998182@mvista.com> <1197508801.22951.40.camel@imap.mvista.com> <20071213101327.GM8977@elte.hu>
In-Reply-To: <20071213101327.GM8977@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712131211.32899.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 December 2007 11:13:27 Ingo Molnar wrote:
> 
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > This driver is scheduled for removal, so I'd not touch it anymore to 
> > > avoid the possibility to introduce a lastminute regression. The new 
> > > drivers (b43 and b43legacy) have this fixed (in a different way by 
> > > completely removing it).
> > 
> > When is the removal scheduled?
> 
> $ grep -i bcm Documentation/feature-removal-schedule.txt
> $
> 
> might make sense to update this file.

Patches are on their way.
I think it's scheduled to be removed after 2.6.25 was released.

-- 
Greetings Michael.
