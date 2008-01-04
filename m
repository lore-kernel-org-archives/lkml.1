Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYADSTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYADSTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 13:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYADSTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 13:19:25 -0500
Received: from mx.treblig.org ([80.68.94.177]:2801 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbYADSTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 13:19:24 -0500
Date: Fri, 4 Jan 2008 18:19:18 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: felix-linuxkernel@fefe.de, linux-kernel@vger.kernel.org
Subject: Re: memory remapping, 4gb memory on 945gt
Message-ID: <20080104181918.GA21797@gallifrey>
References: <20080104154914.GA589@codeblau.de> <p73lk758sri.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73lk758sri.fsf@bingen.suse.de>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 18:15:34 up 45 days, 17:28,  1 user,  load average: 0.44, 0.39, 0.34
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> felix-linuxkernel@fefe.de writes:
> 
> > I recently put 4 GB of memory in my Acer Travelmate 8210 series
> > notebook.  The BIOS only detects 3 GB.
> 
> Actually it will detect 4GB, but put the PCI hole over the last GB.
> One way to get more usable memory is to configure the BIOS to use a smaller
> PCI hole (e.g. use smaller frame buffer/aperture etc.)

Unfortunately there are certainly some that don't make many options
for configuration and also use a vast amount; my Toshiba A100-306
uses an entire 1GB for the PCI space and has very little in the
way of configuration.

> > I googled around a little.  It appears to be a chipset limitation of the
> > 945gt, which uses the fourth gig for devices.
> >
> > Now I can understand this explanation for 32-bit mode, but I'm running
> > in 64-bit mode.  There should be a way to use the fourth gig under
> > Linux.  Is there?
> 
> The chipset limitation applies to 64bit mode as well as to 32bit mode
> (which actually does not have a 4GB limitation with PAE)

Note that some system and memory vendors have incorrect statements
stating that the 3.xGB limit is a 32bit OS issue on these machines
and it'll all just work fine on 64bit OSs.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
