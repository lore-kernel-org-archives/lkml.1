Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZBRAbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZBRAbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZBRAbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:31:15 -0500
Received: from mga05.intel.com ([192.55.52.89]:51078 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752451AbZBRAbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:31:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,225,1233561600"; 
   d="scan'208";a="666377655"
Date: Tue, 17 Feb 2009 16:34:17 -0800
From: mark gross <mgross@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090218003417.GA26292@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <200902160010.16955.rjw@sisk.pl> <20090217215717.GA25605@linux.intel.com> <20090217220439.GA1573@srcf.ucam.org> <200902171419.14823.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902171419.14823.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 02:19:13PM -0800, Jesse Barnes wrote:
> On Tuesday, February 17, 2009 2:04 pm Matthew Garrett wrote:
> > On Tue, Feb 17, 2009 at 01:57:17PM -0800, mark gross wrote:
> > > Putting the wake on key event issue aside, is it possible to have wake
> > > up's on the ms time scale?  I ask because I thought the XO did exactly
> > > this (but left the screen live).  Why does it take 20 sec to get into
> > > or out of S3 on my laptop?
> >
> > Graphics reinit, dumping graphics contents back into RAM, us resuming
> > devices in series, that kind of thing. On some hardware you'll spend a
> > noticable amount of time in the BIOS before any of the Linux resume code
> > gets touched. I thought the XO had got sub second, but I wasn't sure
> > that they were in the low ms range.
> 
> IME a good chunk of it is BIOS time.  On my x200s resume is very fast (on the 
> order of a second or two though I haven't measured), while on my Eee and T61 
> machines it's much slower, even though they're all using Intel gfx.
> 
> Of course we should really be shooting for sub-second times or about the time 
> it takes you to open your lid (or even much faster in the case of demand 
> suspend/resume for servers/desktops).

yeah I was thinking vertical blank refresh times.

We would need a state where the graphics stayed on somehow too.   

--mgross

