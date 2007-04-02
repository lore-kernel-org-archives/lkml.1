Return-Path: <linux-kernel-owner+w=401wt.eu-S965042AbXDBJES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042AbXDBJES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933942AbXDBJES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:04:18 -0400
Received: from mx01.qsc.de ([213.148.129.14]:42886 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933281AbXDBJEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:04:16 -0400
X-Greylist: delayed 1668 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 05:04:16 EDT
From: Rene Rebe <rene@exactcode.de>
Organization: ExactCODE
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
Date: Mon, 2 Apr 2007 10:35:40 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       "Brown, Len" <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <460E0158.7090705@goop.org> <8393D4C0-57C5-4CD2-8CA4-E4241E74FB4E@mac.com>
In-Reply-To: <8393D4C0-57C5-4CD2-8CA4-E4241E74FB4E@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704021035.40672.rene@exactcode.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: Spam detection software, running on the system "grum.localhost", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  On Sunday 01 April 2007 20:57:57 Kyle Moffett wrote: >
	On Mar 31, 2007, at 02:36:08, Jeremy Fitzhardinge wrote: > > When I run
	2.6.21-rc5 + Andi's x86 patches + paravirt_ops patches, > > I've been
	getting my machine shut down with critical thermal > > shutdown
	messages: > > > > Mar 30 23:19:03 localhost kernel: ACPI: Critical trip
	point > > Mar 30 23:19:03 localhost kernel: Critical temperature reached
	(128 > > C), shutting down. > > Mar 30 23:19:03 localhost kernel:
	Critical temperature reached (128 > > C), shutting down. > > Mar 30
	23:19:03 localhost shutdown[19417]: shutting down for system > > halt >
	> > > and the machine does feel pretty hot. Interestingly, when the > >
	machine reboots, the fan spins up to a noticeably higher speed, so > >
	it seems that maybe something is getting fan speed control wrong. > >
	Well, 128C is more than hot enough to boil water and well above the >
	thermal tolerances of most CPUs, so I would imagine that were your > CPU
	actually that hot it wouldn't be capable of printing the > "Critical
	temperature reached" messages, let alone properly rebooting. [...] 
	Content analysis details:   (-1.4 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.4 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 April 2007 20:57:57 Kyle Moffett wrote:
> On Mar 31, 2007, at 02:36:08, Jeremy Fitzhardinge wrote:
> > When I run 2.6.21-rc5 + Andi's x86 patches + paravirt_ops patches,  
> > I've been getting my machine shut down with critical thermal  
> > shutdown messages:
> >
> > Mar 30 23:19:03 localhost kernel: ACPI: Critical trip point
> > Mar 30 23:19:03 localhost kernel: Critical temperature reached (128  
> > C), shutting down.
> > Mar 30 23:19:03 localhost kernel: Critical temperature reached (128  
> > C), shutting down.
> > Mar 30 23:19:03 localhost shutdown[19417]: shutting down for system  
> > halt
> >
> > and the machine does feel pretty hot.  Interestingly, when the  
> > machine reboots, the fan spins up to a noticeably higher speed, so  
> > it seems that maybe something is getting fan speed control wrong.
> 
> Well, 128C is more than hot enough to boil water and well above the  
> thermal tolerances of most CPUs, so I would imagine that were your  
> CPU actually that hot it wouldn't be capable of printing the  
> "Critical temperature reached" messages, let alone properly rebooting.

IIRC a MSI Megabook S270 (I formerly owned) BIOS notifies this
"Critical temperature reached (128C)" when the battery run empty
when the OS did no action due to battery low indications. I guess
the BIOS people thought this is a good last resort to let the OS
really shutdown before the box just turns off.

Yours,

-- 
  René Rebe - ExactCODE GmbH - Europe, Germany, Berlin
  http://exactcode.de | http://t2-project.org | http://rene.rebe.name
  +49 (0)30 / 255 897 45
