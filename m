Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbZAONdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbZAONdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765200AbZAONbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:31:46 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:42797 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765180AbZAONbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:31:45 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <496F3ABF.1020201@cam.ac.uk>
Date: Thu, 15 Jan 2009 13:31:43 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
       LKML <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@openedhand.com>, felipe.balbi@nokia.com,
       Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH 2.6.29-rc1-git4] mfd: da9030 usb charge pump support within
 mfd driver.
References: <496E2BE5.1050803@cam.ac.uk> <f17812d70901141704n1ac3e8a7q56410f175b833ef6@mail.gmail.com> <496ED8F6.6030201@compulab.co.il> <f17812d70901142302n53953607o124df5601cd037bc@mail.gmail.com> <496EE5A4.4010805@compulab.co.il> <f17812d70901150013v2c70047er829b1c884a1d7772@mail.gmail.com> <496F1C7A.5080202@gmail.com> <20090115130230.GG2147@sirena.org.uk>
In-Reply-To: <20090115130230.GG2147@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> ")
> Fcc: +sent-mail
> 
> On Thu, Jan 15, 2009 at 11:22:34AM +0000, Jonathan Cameron wrote:
> 
>>> I would expect the final solution to be clean enough, that requires some
>>> dependent stuffs to be modified, and the final look of this patch may be a
>>> bit different
> 
>> Agreed.  This definitely isn't the way to go in the long run (assuming
>> otg etc get cleaned up)
>> but would it be an acceptable stop gap?  I'm just keen to get the
>> functionality available
>> so as to get a board config (intel stargate 2) sorted.  (some of which
>> you were kind enough to
>> review a while back - thanks).
> 
> Having looked at this problem just this week for some other designs I'm
> thinking the regulator API might be a good fit for this.  It is a supply
> and the API provides a method to match up the supply with the USB
> controller (some designs have multiple options there so that's useful).
> I've not actually tried it yet to see what the pain is like, though.
I did at one point.  The problem here is you aren't simply controlling the
current / voltage. You are switching it between various automatic modes
and a manual override.  Only in the manually overridden states is it
much like a regulator and then it's one with very odd properties.

If these are consistent enough across different pmic's I guess it could
be blugeoned in, but I'm not convinced this is true.

Jonathan



 

