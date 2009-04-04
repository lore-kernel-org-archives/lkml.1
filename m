Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZDDQOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZDDQOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZDDQNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:13:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57937 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZDDQNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:13:50 -0400
Date: Sat, 4 Apr 2009 17:13:35 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Ming Lei <tom.leiming@gmail.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Commit 7a192ec is build breaking
Message-ID: <20090404161335.GA5676@flint.arm.linux.org.uk>
References: <20090328140049.GA4344@flint.arm.linux.org.uk> <20090404041740.GA6504@suse.de> <d82e647a0904040018n6e5a261eodcb42d4bb76e65aa@mail.gmail.com> <20090404094453.GA11209@flint.arm.linux.org.uk> <20090404160851.GA9828@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090404160851.GA9828@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 09:08:51AM -0700, Greg KH wrote:
> On Sat, Apr 04, 2009 at 10:44:53AM +0100, Russell King wrote:
> > Note that since I was sending a new set of ARM fixes a couple of days
> > ago and there didn't seem to be anyone listening to my emails, I fixed
> > the PXA flash driver myself.  Linus now has that fix.
> 
> Sorry, I was out of the country for a week.
> 
> So, we don't need to revert the original change now?

Well, I didn't apply the non-ARM bits of the patch.  So the way forward is
to either revert both mine and the original patch and apply a new one (which
means a total of three commits) or just apply the remainder of my patch I
sent at the top of this thread.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
