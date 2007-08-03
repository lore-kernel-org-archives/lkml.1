Return-Path: <linux-kernel-owner+w=401wt.eu-S1763710AbXHCVeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763710AbXHCVeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 17:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762453AbXHCVeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 17:34:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762250AbXHCVeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 17:34:22 -0400
Date: Fri, 3 Aug 2007 17:31:24 -0400
From: Dave Jones <davej@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by
	default on certain device classes
Message-ID: <20070803213124.GB28517@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
	linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
	linux-usb-devel@lists.sourceforge.net
References: <20070803201239.GB20376@redhat.com> <Pine.LNX.4.44L0.0708031716030.5099-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708031716030.5099-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 05:17:24PM -0400, Alan Stern wrote:
 > On Fri, 3 Aug 2007, Dave Jones wrote:
 > 
 > > here's a head start for you.
 > > 
 > > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243038
 > > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246713
 > > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243953
 > > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242359
 > > 
 > > That's just the ones that were handy..
 > 
 > The last report appears to be related more to the EHCI-cpufreq problem, 
 > for which a patch was recently posted.

I was a bit iffy about including that one, but decided to because
some of the reporters noted that the problem 'went away' after
we pushed out a kernel disabling usb suspend by default.
See comments 16 & 17.

Clearly not the problem everyone was seeing, but it looks like
a few people piled on one bug with the same symptom from multiple
problems.

	Dave

-- 
http://www.codemonkey.org.uk
