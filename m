Return-Path: <linux-kernel-owner+w=401wt.eu-S1762711AbXEQVxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762711AbXEQVxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758383AbXEQVxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:53:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39313 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756493AbXEQVxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:53:21 -0400
Date: Thu, 17 May 2007 23:53:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Message-ID: <20070517215321.GC7336@elf.ucw.cz>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <20070517092318.GD3975@ucw.cz> <464C5A62.6060604@gmail.com> <200705171508.40202.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705171508.40202.lenb@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-05-17 15:08:39, Len Brown wrote:
> On Thursday 17 May 2007 09:36, Maciej Rutecki wrote:
> 
> > Many people need change trippoints, for example I have:
> > 
> > cat /proc/acpi/thermal_zone/TZ0/trip_points  | grep critical
> > critical (S5):           256 C
> > 
> > I _must_ change it to below 105 C, or edit DSDT table (too difficult to
> > me). I cannot use this kernel, when trip points are read only.
> 
> What bad things happen if you leave the critical trip point at 256?
> Do you find that you can drive the temperature over 105 and
> the system fails to shut down?

Something similar happened to me on XE3, yes.

(Actual values were different; BIOS specified critical temperature at
cca 95C, but hw killed the power at cca 83C. Setting critical trip
point at 80C made the problem go away.)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
