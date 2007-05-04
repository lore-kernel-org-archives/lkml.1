Return-Path: <linux-kernel-owner+w=401wt.eu-S1767701AbXEDFyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767701AbXEDFyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767703AbXEDFyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:54:38 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4550 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767701AbXEDFyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:54:37 -0400
Date: Fri, 4 May 2007 06:54:26 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "David M. Lloyd" <dmlloyd@flurg.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Glen Turner <gdt@gdt.id.au>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Detecting process death for anycast named process monitoring
Message-ID: <20070504055425.GA24362@flint.arm.linux.org.uk>
Mail-Followup-To: "David M. Lloyd" <dmlloyd@flurg.com>,
	Chris Friesen <cfriesen@nortel.com>, Glen Turner <gdt@gdt.id.au>,
	Linux kernel <linux-kernel@vger.kernel.org>
References: <4638FCEA.4010806@gdt.id.au> <4639111A.70202@nortel.com> <1178147547.26507.96.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178147547.26507.96.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 06:12:27PM -0500, David M. Lloyd wrote:
> On Wed, 2007-05-02 at 16:30 -0600, Chris Friesen wrote:
> > Glen Turner wrote:
> > 
> > > The question is, how can a process with no relationship to another
> > > process detect that process unexpectedly dying?  If named goes
> > > away to a better place, we want to shut down the interface
> > > which causes Quagga to inject the anycast route.
> 
> > We did something similar where arbitrary processes can register to be 
> > sent an arbitrary signal when the state of other processes change.
> 
> What about something like inotify, but for processes?  That would be
> cool...

Or maybe just ignoring the SIGHUP before exec'ing the named process as
a child.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
