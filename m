Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZDFUEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZDFUEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZDFUEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:04:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44952 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbZDFUEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:04:23 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: [PATCH] acer-wmi: don't bother loading on unsupported systems
Date: Mon, 6 Apr 2009 16:04:12 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: aceracpi@googlegroups.com, linux-kernel@vger.kernel.org
References: <200904060940.16889.jarod@redhat.com> <200904062053.12303.carlos@strangeworlds.co.uk>
In-Reply-To: <200904062053.12303.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904061604.12713.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009 15:53:11 Carlos Corbacho wrote:
> On Monday 06 April 2009 14:40:16 Jarod Wilson wrote:
> > So have acer-wmi just bail on unsupported systems -- includes only my
> > particular model of the Aspire One atm, but a larger list of unsupported
> > systems can be found here:
> >
> > http://code.google.com/p/aceracpi/wiki/SupportedHardware
> >
> > This might well become unnecessary once the WMI sysfs interface mentioned
> > in acer-wmi.c exists and the wild-card dmi modalias is gone, but for now...
> > I prefer to have working wireless, and this isn't exactly an obvious root
> > cause. I lack the hardware to further extend the blacklist, but doing so is
> > trivial. Whether or not loading acer-wmi actually negatively impacts
> > machines other than the AAO is unknown at this time.
> 
> NAK.
> 
> An equivalent patch to this was submitted to the ACPI tree two days ago (which 
> blacklists both the known Aspire One DMI entries) and is now upstream (and 
> will also be backported to the next stable release).
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a74dd5fdabcd34c93e17e9c7024eeb503c92b048

Heh, that's what I get for waiting two days before actually submitting... ;)

Works for me.

-- 
Jarod Wilson
jarod@redhat.com
