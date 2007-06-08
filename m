Return-Path: <linux-kernel-owner+w=401wt.eu-S967133AbXFHB63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967133AbXFHB63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764777AbXFHB6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:58:22 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:45036 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXFHB6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:58:21 -0400
Date: Thu, 07 Jun 2007 19:57:26 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-reply-to: <fa.x8ZCt4n0yXI1llhRq4wfjNfqK4w@ifi.uio.no>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Message-id: <4668B786.7030900@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.i7vJP3lxWAlyOLjcsqOWPKlixD8@ifi.uio.no>
 <fa.3ijVoClbWNHWrMhDABWjNPxp+wo@ifi.uio.no>
 <fa.ZqgSvRGj/scOmd0AwnU6e21Gcwc@ifi.uio.no>
 <fa.oNsjw768fkDpx3oef91fjAQs1Iw@ifi.uio.no>
 <fa.x8ZCt4n0yXI1llhRq4wfjNfqK4w@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
>> Note that your boot also mentions this:
>>
>> [  106.449661] mtrr: no more MTRRs available
>>
>> which indicates that things like X may not be able to map the
>> framebuffer with the 'write-combine' attribute, which will hurt
>> performance.  I've heard reports that turning of 'Intel QST fan
>> control' in your BIOS settings will prevent all your MTRRs from being
>> used (improperly, probably another BIOS bug) so that X will perform
>> well.  But if you don't use X on this machine, you don't have to worry
>> about it.  The other option would be to remap your MTRRs by hand to
>> free one up for X, you can do that by combining the last one or two
>> entries into a single MTRR using the API described in
>> Documentation/mtrr.txt before you start X.
>>
>> Jesse
>>
> 
> FYI--
> 
> [  106.449661] mtrr: no more MTRRs available
> 
> This has always occurred, even with mem=8832M setting.
> 
> Justin.

Yes, it's another consequence of the way your BIOS configured the MTRRs 
(wastefully, using more of the precious register entries than it needed 
to, in addition to not covering all of the RAM).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

