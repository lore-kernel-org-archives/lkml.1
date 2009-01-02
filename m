Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZABCCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZABCCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 21:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZABCB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 21:01:58 -0500
Received: from mga05.intel.com ([192.55.52.89]:4399 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755411AbZABCB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 21:01:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,316,1228118400"; 
   d="scan'208";a="654035764"
Date: Thu, 1 Jan 2009 18:01:48 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Julia Lawall <julia@diku.dk>, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] include/linux: Move definitions from usb.h to usb/ch9.h
Message-ID: <20090102020121.GA9411@gamba.jf.intel.com>
References: <Pine.LNX.4.64.0812292247300.2265@ask.diku.dk> <20081230233727.GA12819@gamba.jf.intel.com> <200812301740.26432.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200812301740.26432.david-b@pacbell.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 05:40:26PM -0800, David Brownell wrote:
> On Tuesday 30 December 2008, Sarah Sharp wrote:
> > so why move these functions to 
> > include/linux/usb/ch9.h?  Was it confusing to find these functions, or do you
> > have an overall plan for these changes?
> 
> You missed earlier mail on the topic.  The basic issue is
> that those symbols can (and should!) be used for peripheral
> side support as well as host side support ... which means
> they should never have been put into a host-only header.

Ah, I see.  Thanks for the explanation. :)

Sarah
