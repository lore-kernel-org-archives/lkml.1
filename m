Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZBQWFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZBQWFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZBQWEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:04:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46589 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZBQWEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:04:53 -0500
Date: Tue, 17 Feb 2009 22:04:39 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: mark gross <mgross@linux.intel.com>
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090217220439.GA1573@srcf.ucam.org>
References: <200902160010.16955.rjw@sisk.pl> <20090216225831.GH1370@ucw.cz> <20090216231324.GA15435@srcf.ucam.org> <20090217215717.GA25605@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217215717.GA25605@linux.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 01:57:17PM -0800, mark gross wrote:

> Putting the wake on key event issue aside, is it possible to have wake
> up's on the ms time scale?  I ask because I thought the XO did exactly
> this (but left the screen live).  Why does it take 20 sec to get into
> or out of S3 on my laptop?

Graphics reinit, dumping graphics contents back into RAM, us resuming 
devices in series, that kind of thing. On some hardware you'll spend a 
noticable amount of time in the BIOS before any of the Linux resume code 
gets touched. I thought the XO had got sub second, but I wasn't sure 
that they were in the low ms range.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
