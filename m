Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYAIM0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYAIM0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYAIM0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:26:12 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49484 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbYAIM0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:26:12 -0500
Date: Wed, 9 Jan 2008 07:25:56 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Martin Schwidefsky <schwidefsky@googlemail.com>
Cc: Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080109122556.GL21097@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Martin Schwidefsky <schwidefsky@googlemail.com>,
	Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <p73odbwqmx2.fsf@bingen.suse.de> <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi> <20080108181525.GL27800@mit.edu> <6e0cfd1d0801090154r75c9ca93v5361aea45fe41bb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e0cfd1d0801090154r75c9ca93v5361aea45fe41bb5@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 10:54:11AM +0100, Martin Schwidefsky wrote:
> On Jan 8, 2008 7:15 PM, Theodore Tso <tytso@mit.edu> wrote:
> > That will fix the this issue.  The problem you are facing is that you
> > have your hardware clock set to ticking localtime, instead of GMT.
> > Windows ticks localtime, which is a mistake carried over from the
> > 1970's and MS-DOS.  Ticking localtime has all sorts of problems, among
> > which is if you reboot around the transition between Summer Time (or
> > Daylight Savings Time, depending on your contry) and normal time, the
> > OS has no idea whether the DST adjustment has been applied or not.
> 
> Actually you can force Windows to accept a hardware clock in UTC:
> HKEY_LOCAL_MACHINE/SYSTEMCurrentControlSetControl/TimeZoneInformation/RealTimeIsUniversal

Oh, so cool!!!  Do you know off hand what version of Windows started
honoring that registry setting? 

And what do you set that registry value to?  Just a boolean "true"?

Now, how to convince Ubuntu to put this in their FAQ so I stop having
their ahhh, less than clueful dual-booting Windows users who happen to
live in Europe stop submitting bugs on this issue....

						- Ted
