Return-Path: <linux-kernel-owner+w=401wt.eu-S1751433AbYHLLaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbYHLLaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 07:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYHLLaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 07:30:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38288 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYHLLaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 07:30:03 -0400
Date: Tue, 12 Aug 2008 13:02:59 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
Message-ID: <20080812110259.GA15911@elf.ucw.cz>
References: <20080806090246.GA1572@elf.ucw.cz> <87bq046cht.fsf@basil.nowhere.org> <20080812094135.GA1565@elf.ucw.cz> <20080812105409.GA1366@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812105409.GA1366@one.firstfloor.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-12 12:54:09, Andi Kleen wrote:
> On Tue, Aug 12, 2008 at 11:41:35AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > Aug  6 11:00:10 amd kernel: ACPI: Critical trip point
> > > > Aug  6 11:00:10 amd kernel: Critical temperature reached (128 C),
> > > > shutting down.
> > > > Aug  6 11:00:10 amd shutdown[24414]: shutting down for system halt
> > > >
> > > > ...and machine went down at that point :-(.
> > > 
> > > I hope you can easily reproduce it?
> > > 
> > > So it's new in 2.6.27rc1 and wasn't in 2.6.26? Can you please
> > 
> > Yes, I'm very sure. It makes machine basically unusable.
> 
> Does this mean you can easily reproduce it?  
> Please do a bisect then. 

It is easily reproduced, but it takes 10+ minutes, and at the end
machine is so hot it will not even power up. So yes, bisect is
possible, but I'd prefer to avoid it.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
