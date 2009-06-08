Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbZFHJEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbZFHJEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 05:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbZFHJD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 05:03:56 -0400
Received: from smtp.nokia.com ([192.100.105.134]:54322 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbZFHJD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 05:03:56 -0400
Date: Mon, 8 Jun 2009 12:01:20 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Luke-Jr <luke@dashjr.org>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Solution: N810 keyboard regression
Message-ID: <20090608090120.GH23310@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <200906061651.43882.luke@dashjr.org> <20090606224204.GA16764@nokia.com> <200906061815.48026.luke@dashjr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906061815.48026.luke@dashjr.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-OriginalArrivalTime: 08 Jun 2009 09:03:41.0169 (UTC) FILETIME=[04A71E10:01C9E818]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 07, 2009 at 01:15:35AM +0200, ext Luke-Jr wrote:
> > did you try changing that keysize calculation ?
> 
> No, I wanted to get the opinion of someone who knows how that code actually is 
> supposed to work before I try randomly changing things I don't understand.
> 
> > Do you see irqs comming? Any debugging messages ?
> 
> There were no debugging messages when the broken keys were pressed, nor did a 
> dbg I added to the driver get triggered for them.

looks like we're gonna need one of the original writes to take a look at
this. I don't know the chip that well and don't have enough time to look
for the docs...

but I still suggest you try changing that line and see what happens
though

-- 
balbi
