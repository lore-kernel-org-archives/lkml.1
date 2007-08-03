Return-Path: <linux-kernel-owner+w=401wt.eu-S1763493AbXHCO6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763493AbXHCO6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762484AbXHCO6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:58:37 -0400
Received: from twin.jikos.cz ([213.151.79.26]:38713 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762568AbXHCO6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:58:37 -0400
Date: Fri, 3 Aug 2007 16:58:09 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Dave Jones <davej@redhat.com>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default
 on certain device classes
In-Reply-To: <20070803145321.GB17138@redhat.com>
Message-ID: <Pine.LNX.4.64.0708031655180.26230@twin.jikos.cz>
References: <20070803140909.GA19245@srcf.ucam.org>
 <Pine.LNX.4.44L0.0708031014160.3416-100000@iolanthe.rowland.org>
 <20070803143338.GA19713@srcf.ucam.org> <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz>
 <20070803145321.GB17138@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Dave Jones wrote:

> Interesting.  Which devices did you notice failing? Was it a case that 
> they would sleep and not come back out of that state?

Random keyboards, even connection to EHCI/OHCI seemed to make difference. 
We have been doing some experiments with Alan during OLS and it seemed 
quite hopeless.

A few keyboards we have been testing with seemed to be losing keypressess 
when coming out of suspend (if and only if the root hub wasn't suspended 
too, etc. Magic).

-- 
Jiri Kosina
