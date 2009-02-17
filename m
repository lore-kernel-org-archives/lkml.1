Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbZBQOTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbZBQOTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZBQOTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:19:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46651 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZBQOTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:19:41 -0500
Date: Tue, 17 Feb 2009 14:19:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Brian Swetland <swetland@google.com>
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090217141924.GA25335@srcf.ucam.org>
References: <200902160010.16955.rjw@sisk.pl> <20090216225831.GH1370@ucw.cz> <20090216231324.GA15435@srcf.ucam.org> <20090216232259.GK1370@ucw.cz> <20090216232619.GB15678@srcf.ucam.org> <20090217141434.GA12378@bulgaria.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217141434.GA12378@bulgaria.corp.google.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 06:14:34AM -0800, Brian Swetland wrote:
> [Matthew Garrett <mjg59@srcf.ucam.org>]
> > https://lists.linux-foundation.org/pipermail/linux-pm/2009-January/019493.html 
> > says that they're the same on their current platform.
> 
> Well on the Qualcomm MSM72xx SoCs, yeah they're pretty similar -- we can
> reasonably enter power collapse (full shutdown of the ARM11 and
> peripherals) from idle.  But this is not (to my knowledge) true of *all*
> SoCs out there.  Also, resuming from this state can take 5-30ms
> (depending on how distracted the baseband processor is by what's going
> on on the network).

Mm. Resume from deep idle on x86 is typically in the usec range, but 
this is the kind of constraint that pm_qos exposes nicely.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
