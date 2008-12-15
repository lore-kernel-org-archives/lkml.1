Return-Path: <linux-kernel-owner+w=401wt.eu-S1751547AbYLOMK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbYLOMK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 07:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYLOMKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 07:10:15 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:42850 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYLOMKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 07:10:14 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <49464922.1070404@cam.ac.uk>
Date: Mon, 15 Dec 2008 12:10:10 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Mike Rapoport <mike@compulab.co.il>, LKML <linux-kernel@vger.kernel.org>,
       felipe.balbi@nokia.com, Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH] mfd: DA9030 USB charge pump mode selection support
References: <4943FA3E.9090507@cam.ac.uk> <49461CFB.9080108@compulab.co.il> <20081215104730.GA31145@sirena.org.uk>
In-Reply-To: <20081215104730.GA31145@sirena.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Mon, Dec 15, 2008 at 11:01:47AM +0200, Mike Rapoport wrote:
>> Jonathan Cameron wrote:
> 
>>> The main question on this is whether it should just be rolled into
>>> the core mfd driver.  I'm inclined to keep it separate and decidedly
>>> optional as the fact it isn't already in the driver implies that
>>> it may not be commonly used. (Intel Stargate 2 does need this
>>> functionality though, hence the submission as I'm hoping to get
>>> the relevant board code in soonish.)
> 
>> I'm for adding "da9030_set_usb_charge_pump_mode" to the core mfd driver.
> 
> Me too - if there are concerns about kernel size a config option could
> be added to allow users to select it.  Unless we get an abstraction for
> these USB power sources (which might be useful) a separate driver
> doesn't seem to buy much.
> 
Fair enough, I'll admit I thought there would be rather more to it when I
started writing that!

New patch to follow shortly.

Jonathan
