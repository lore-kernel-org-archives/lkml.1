Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZKTLHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZKTLHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZKTLHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:07:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52742 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZKTLHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:07:49 -0500
Date: Fri, 20 Nov 2009 11:07:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, Brian Swetland <swetland@google.com>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] staging/dream: add missing include files
Message-ID: <20091120110728.GB10644@n2100.arm.linux.org.uk>
References: <20091101222717.GB20740@elf.ucw.cz> <20091119225602.GC18710@kroah.com> <20091120105726.GH11212@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120105726.GH11212@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 11:57:26AM +0100, Pavel Machek wrote:
> On Thu 2009-11-19 14:56:02, Greg KH wrote:
> > On Sun, Nov 01, 2009 at 11:27:17PM +0100, Pavel Machek wrote:
> > > +config GENERIC_GPIO
> > > +	bool
> > > +	default y
> > 
> > Which breaks the i386 build.  Don't force on a general config option
> > like this, that's not nice at all :(
> 
> Ok, I should figure out how to limit it to arch-msm.

You do it by 'select'ing the symbol in arch/arm/Kconfig.  See the many
other examples therein of how to do it.
