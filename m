Return-Path: <linux-kernel-owner+w=401wt.eu-S1764965AbXEZViz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764965AbXEZViz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 17:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764561AbXEZVio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 17:38:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36209 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760309AbXEZVin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 17:38:43 -0400
Message-ID: <4658A8DE.80107@garzik.org>
Date: Sat, 26 May 2007 17:38:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Dillow <dave@thedillows.org>
CC: dean gaudet <dean@arctic.org>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFT, v4] sata_mv: convert to new EH
References: <20070225233454.GA31282@havoc.gtf.org>	 <1173158201.3416.8.camel@obelisk.thedillows.org>	 <45ED039E.20608@garzik.org>	 <1173164261.3416.15.camel@obelisk.thedillows.org>	 <4656EB26.40504@garzik.org> <4657A678.8090308@garzik.org>	 <Pine.LNX.4.64.0705252335590.8327@twinlark.arctic.org>	 <46589F15.8080003@garzik.org> <1180213892.19231.6.camel@obelisk.thedillows.org>
In-Reply-To: <1180213892.19231.6.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Dillow wrote:
> On Sat, 2007-05-26 at 16:56 -0400, Jeff Garzik wrote:
>> Dave, any chance you could try 2.6.22-rc3 + my v4 patch, on a different 
>> hard drive?  Preferably a non-Maxtor, or at least not another Maxtor 
>> 6L200S0.  If that's a big deal, don't worry about it.  I just want to 
>> rule out buggy firmware and/or bad hard drive in your case.
> 
> It is likely I can come up with at least one, and maybe two if I
> cannibalize my main machine... do you want results under all three
> kernels or just the v4 patch?

Mainly the v4 patch, but an it-works test on 2.6.22-rc3 just for 
sanity's sake would be useful as well.

If you have time, check both new and old drives with SMART
	smartctl -d ata -t long /dev/blahblah

to make sure the extended tests don't find anything wrong.  Extended 
tests usually take 30-90 minutes.  You can access the hard drive while 
the extended test is running, but I/O will be slower for obvious reasons.

	Jeff



