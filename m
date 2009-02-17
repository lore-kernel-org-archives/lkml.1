Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbZBQOQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbZBQOQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZBQOPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:15:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:23636 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZBQOPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:15:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:organization:
	user-agent:x-system-of-record;
	b=NaZwo0GTuWAKfGtJdYMUcWWkPApTRYQjdCLznfmjwyW8EMmnfh9S+n1n1ZDcBW2b8
	Z+N1uXrIg/Frx7ftowfAA==
Date: Tue, 17 Feb 2009 06:14:34 -0800
From: Brian Swetland <swetland@google.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
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
Message-ID: <20090217141434.GA12378@bulgaria.corp.google.com>
References: <200902160010.16955.rjw@sisk.pl> <20090216225831.GH1370@ucw.cz> <20090216231324.GA15435@srcf.ucam.org> <20090216232259.GK1370@ucw.cz> <20090216232619.GB15678@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216232619.GB15678@srcf.ucam.org>
Organization: Google, Inc.
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Matthew Garrett <mjg59@srcf.ucam.org>]
> On Tue, Feb 17, 2009 at 12:22:59AM +0100, Pavel Machek wrote:
> > On Mon 2009-02-16 23:13:24, Matthew Garrett wrote:
> > > Meanwhile, on embedded it's becoming a less interesting problem because 
> > > idle and suspended are often now equivalent states. 
> > 
> > Android people tell us otherwise.
> 
> https://lists.linux-foundation.org/pipermail/linux-pm/2009-January/019493.html 
> says that they're the same on their current platform.

Well on the Qualcomm MSM72xx SoCs, yeah they're pretty similar -- we can
reasonably enter power collapse (full shutdown of the ARM11 and
peripherals) from idle.  But this is not (to my knowledge) true of *all*
SoCs out there.  Also, resuming from this state can take 5-30ms
(depending on how distracted the baseband processor is by what's going
on on the network).

Brian
