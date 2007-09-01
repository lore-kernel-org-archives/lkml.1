Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbXIARWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbXIARWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 13:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbXIARWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 13:22:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbXIARWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 13:22:41 -0400
Date: Sat, 1 Sep 2007 13:22:31 -0400
From: Dave Jones <davej@redhat.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
Message-ID: <20070901172231.GA28391@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain> <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010435070.26137@localhost.localdomain> <46D9306C.9040301@s5r6.in-berlin.de> <Pine.LNX.4.64.0709010533260.29190@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709010533260.29190@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2007 at 05:41:06AM -0400, Robert P. J. Day wrote:

 > this whole attribute thing is not adding anything breathtaking new,
 > it's simply taking the example set by EXPERIMENTAL and generalizing
 > it and making it more convenient in the process.

The problem I see with this whole maturity levels idea is that you've
missed that 'EXPERIMENTAL' is largely a complete failure because
everyone ends up enabling it due to needing something dependant on it.

People just don't care about how mature an option is if they need
a driver/feature.  *No-one* is going to come across options and think 
"Oh, the driver for my network card isn't stable. Guess I'll not enable it".
And the idea of hiding the options behind multiple levels of
maturity options sounds completely batshit.

Introducing multiple levels of EXPERIMENTAL is just introducing
more symbols of zero value because everyone will end up enabling
them just to get things done.

	Dave

-- 
http://www.codemonkey.org.uk
