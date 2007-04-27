Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbXD0Otd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbXD0Otd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbXD0Otd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:49:33 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:36049 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755906AbXD0Otb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:49:31 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Fri, 27 Apr 2007 08:49:49 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Jean Delvare" <khali@linux-fr.org>
cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "David Brownell" <david-b@pacbell.net>,
       "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Deepak Saxena" <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       "Christer Weinigel" <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070427144949.GD28203@cosmic.amd.com>
References: <20070419205942.GC5577@csclub.uwaterloo.ca>
 <20070420194933.0813a359@hyperion.delvare>
 <20070422154151.GJ5575@csclub.uwaterloo.ca>
 <20070423114254.71787844@hyperion.delvare>
 <20070423144710.GD1372@cosmic.amd.com>
 <20070426145634.3ac2b7a3@hyperion.delvare>
 <20070426132905.GP5575@csclub.uwaterloo.ca>
 <20070426133920.GA25456@cosmic.amd.com>
 <20070426140323.GE5577@csclub.uwaterloo.ca>
 <20070427100204.403d068c@hyperion.delvare>
MIME-Version: 1.0
In-Reply-To: <20070427100204.403d068c@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 Apr 2007 14:49:16.0269 (UTC)
 FILETIME=[3A6B89D0:01C788DB]
X-WSS-ID: 6A2CD2E71GC695297-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/04/07 10:02 +0200, Jean Delvare wrote:
> On Thu, 26 Apr 2007 10:03:23 -0400, Lennart Sorensen wrote:
> > On Thu, Apr 26, 2007 at 07:39:20AM -0600, Jordan Crouse wrote:
> > > There is no ISA on the LX.
> > 
> > Isn't LPC a good equivalent?
> 
> I suspect that Jordan meant that there is no LPC either. In which case,
> of course, there's no way scx200_acb will ever work on that system, and
> GPIO-based bitbanging is the way to go. Just using i2c-gpio rather than
> scx200_i2c.

This is getting confusing... :)  On the sc1200 and and GX1, the ACB
bus is accessed through ISA ports.  There is no ISA on the cs5535/cs5536
companion chips (accompanying the GX and LX processors), and the ACB
is accessed through PCI.  All the platforms have LPC, but that really
doesn't matter for the purposes of this discussion.

The silicon block that implements the ACB has been generally unchanged
over the last 6 or 7 years, so the same driver should support any of
the platforms, assuming one can invoke the magic spells to get at the
hardware.  Jean and I have been concentrating most of our effort on 
getting the GX and LX to work through PCI, and really haven't concentrated
our efforts on the older processors.  Thats not to say it won't work,
but its probably not plug and play.

Jordan

-- 
Jordan Crouse
Senior Linux Engineer
Advanced Micro Devices, Inc.
<www.amd.com/embeddedprocessors>


