Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbZAHMZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbZAHMZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZAHMZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:25:33 -0500
Received: from www.tglx.de ([62.245.132.106]:49107 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZAHMZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:25:33 -0500
Date: Thu, 8 Jan 2009 13:25:25 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Davide Rizzo <elpa.rizzo@gmail.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, ben-linux@fluff.org
Subject: Re: [PATCH 1/2] Driver for user access to internal timer
Message-ID: <20090108122524.GC3053@local>
References: <8447d6730901080205o1a337d4cx867c7b2bd429ceb0@mail.gmail.com> <20090108112959.GB3053@local> <8447d6730901080337r190770d5s5eca64720bb7330f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8447d6730901080337r190770d5s5eca64720bb7330f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 12:37:04PM +0100, Davide Rizzo wrote:
> >
> > Davide,
> > please don't use drivers/uio/ for things that are no UIO drivers.
> >
> > Thanks,
> > Hans
> 
> I thought drivers/uoi is a better choice then driver/misc, because
> this driver allows user to access internal hardware to generate PWM
> signals.

Yes, but you do not use the UIO framework to achieve this.

> Otherwise, where do you suggest to put it ?

I didn't have a deeper look at your driver. I suggest you ask the people
who maintain the clock/timer frameworks you use. Since you seem to be
working on an ARM platform, you should Cc: the linux-arm-kernel mailing
list as well.

Thanks,
Hans

