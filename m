Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbXELR4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbXELR4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 13:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbXELR4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 13:56:42 -0400
Received: from [71.237.232.134] ([71.237.232.134]:43626 "EHLO
	laptopd505.fenrus.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753215AbXELR4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 13:56:41 -0400
X-Greylist: delayed 669 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 May 2007 13:56:41 EDT
Subject: Re: [announce] Intel announces the PowerTOP utility for Linux
From: Arjan van de Ven <arjan@linux.intel.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0705121256430.9570@yvahk01.tjqt.qr>
References: <4644F726.1050806@linux.intel.com>
	 <Pine.LNX.4.61.0705121256430.9570@yvahk01.tjqt.qr>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 12 May 2007 10:44:11 -0700
Message-Id: <1178991851.3591.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 13:00 +0200, Jan Engelhardt wrote:
> On May 11 2007 16:07, Arjan van de Ven wrote:
> >
> > A typical Linux distribution has many components that wake the processor up
> > frequently for no good reason. In our testing with PowerTOP, we have seen many
> > cases where with some simple fixes, the battery life of typical laptops was
> > increased by one hour or more!
> >
> > We are providing fixes for several of the issues we identified, and we
> > encourage the Linux community to help us in this quest to get the maximum
> > battery life out of your (hopefully Intel based) laptops. Try the PowerTOP
> > tool, join the mailing list or the IRC channel and provide feedback, problem
> > reports or fixes!
> 
> Yeah, hal happily wakes up every two seconds. So much for
> the effectivity of NO_HZ.


The AN patches that Kristen posted a few days ago will fix this part of
hal for real... assuming you have hardware with AN support that is.

they are in -mm now... should go mainline in like 2.6.23

