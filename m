Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZLHKQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZLHKQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 05:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZLHKQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 05:16:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51945 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbZLHKQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 05:16:04 -0500
Date: Tue, 8 Dec 2009 11:16:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, Brian Swetland <swetland@google.com>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] staging/dream: add missing include files
Message-ID: <20091208101559.GF12264@elf.ucw.cz>
References: <20091101222717.GB20740@elf.ucw.cz>
 <20091119225602.GC18710@kroah.com>
 <20091120105726.GH11212@elf.ucw.cz>
 <20091120110728.GB10644@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120110728.GB10644@n2100.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-11-20 11:07:28, Russell King - ARM Linux wrote:
> On Fri, Nov 20, 2009 at 11:57:26AM +0100, Pavel Machek wrote:
> > On Thu 2009-11-19 14:56:02, Greg KH wrote:
> > > On Sun, Nov 01, 2009 at 11:27:17PM +0100, Pavel Machek wrote:
> > > > +config GENERIC_GPIO
> > > > +	bool
> > > > +	default y
> > > 
> > > Which breaks the i386 build.  Don't force on a general config option
> > > like this, that's not nice at all :(
> > 
> > Ok, I should figure out how to limit it to arch-msm.
> 
> You do it by 'select'ing the symbol in arch/arm/Kconfig.  See the many
> other examples therein of how to do it.

Thanks.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
