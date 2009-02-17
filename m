Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbZBQVyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbZBQVyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZBQVyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:54:01 -0500
Received: from mga05.intel.com ([192.55.52.89]:9251 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751385AbZBQVyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:54:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,225,1233561600"; 
   d="scan'208";a="431750220"
Date: Tue, 17 Feb 2009 13:57:17 -0800
From: mark gross <mgross@linux.intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
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
Message-ID: <20090217215717.GA25605@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <200902160010.16955.rjw@sisk.pl> <20090216225831.GH1370@ucw.cz> <20090216231324.GA15435@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216231324.GA15435@srcf.ucam.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 11:13:24PM +0000, Matthew Garrett wrote:
> On Mon, Feb 16, 2009 at 11:58:31PM +0100, Pavel Machek wrote:
> 
> > If no devices are being used, and next wakeup is far enough in the
> > future, just put system to sleep. Long enough == so far away that
> > suspend/wakeup is short compared to that... like 20 seconds on PC.
> 
> This is intrinsically difficult with PCs, since we have such a poorly 
> defined set of wakeup events. We can't wakeup on generic network 
> traffic, just WoL. Many machines won't wake up on keyboard events. 
> Meanwhile, on embedded it's becoming a less interesting problem because 
> idle and suspended are often now equivalent states. Concentrating on 
> runtime PM of as much hardware as possible is arguably more interesting 
> for the majority of use cases.

Putting the wake on key event issue aside, is it possible to have wake
up's on the ms time scale?  I ask because I thought the XO did exactly
this (but left the screen live).  Why does it take 20 sec to get into
or out of S3 on my laptop?

--mgross

> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org
