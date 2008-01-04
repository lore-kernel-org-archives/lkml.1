Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYADQcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYADQcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYADQcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:32:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40915 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbYADQcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:32:10 -0500
Date: Fri, 4 Jan 2008 10:29:39 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben@fluff.org>,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com,
       bryan.wu@analog.com
Subject: Re: [PATCH 2/3] Rework arch specific Makefiles to use mkubootimg
Message-ID: <20080104102939.2e97c076@zod.rchland.ibm.com>
In-Reply-To: <20080104160445.GA27269@flint.arm.linux.org.uk>
References: <20080103160104.171f9aaa@zod.rchland.ibm.com>
	<20080103160406.7ef5ecfe@zod.rchland.ibm.com>
	<20080103224139.GA4178@fluff.org.uk>
	<20080103165854.0d6accef@zod.rchland.ibm.com>
	<20080104040119.GA10268@linux-sh.org>
	<20080104091928.GA28547@flint.arm.linux.org.uk>
	<20080104103345.GA15184@linux-sh.org>
	<20080104054802.40325b15@zod.rchland.ibm.com>
	<20080104160445.GA27269@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008 16:04:45 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Fri, Jan 04, 2008 at 05:48:02AM -0600, Josh Boyer wrote:
> > Rework the architecture specific Makefiles to use the in-kernel version of
> > the mkubootimg tool.
> > 
> > Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> 
> From the point of view of no overall change: Ack.

Ok, thanks.  As it really is no change from the current status quo,
I'll go with this until something happens from the discussion below.

> From the point of view of whether we should have this in the kernel:
> probably not.
> 
> See http://lists.arm.linux.org.uk/lurker/thread/20071203.131631.85e7a1a5.en.html#20071203.131631.85e7a1a5
> 
> for a recent discussion on the ins and outs, multiple formats, options
> and so forth passed to mk(u)image.  It looks like we're heading for 5 or
> 6 different kernel image formats for the ARM architecture. ;(

Hm, that's a bit unfortunate indeed.  I'm not very familiar with ARM,
but is there a "majority" image format that is used?  If so, we could
have the kernel build system generate that by default for uImages.

If not, perhaps it would be better to remove the uImage stuff
completely for ARM as you hinted at in that thread.  The other
architectures don't seem to suffer from as many differences and are
probably OK.

josh
