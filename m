Return-Path: <linux-kernel-owner+w=401wt.eu-S1161107AbXDVXl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161107AbXDVXl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161108AbXDVXl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:41:29 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:43454 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161107AbXDVXl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:41:28 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Sun, 22 Apr 2007 17:41:41 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: lsorense@csclub.uwaterloo.ca
cc: "Jean Delvare" <khali@linux-fr.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "David Brownell" <david-b@pacbell.net>,
       "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Deepak Saxena" <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       "Christer Weinigel" <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070422234141.GA11045@cosmic.amd.com>
References: <11765554074106-git-send-email-hskinnemoen@atmel.com>
 <20070414163418.20490fe2@dhcp-252-105.norway.atmel.com>
 <20070414192807.60bdf84b@hyperion.delvare>
 <20070418174256.GB5577@csclub.uwaterloo.ca>
 <20070419085413.1520feef@hyperion.delvare>
 <20070419205942.GC5577@csclub.uwaterloo.ca>
 <20070420194933.0813a359@hyperion.delvare>
 <20070422154151.GJ5575@csclub.uwaterloo.ca>
MIME-Version: 1.0
In-Reply-To: <20070422154151.GJ5575@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 22 Apr 2007 23:41:17.0463 (UTC)
 FILETIME=[B8DE7270:01C78537]
X-WSS-ID: 6A352D171GC43436-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/07 11:41 -0400, lsorense@csclub.uwaterloo.ca wrote:
> scx200_acb doesn't detect any device that it can drive (nothing in dmesg
> at all when loaded) on the sc1200.  I believe the main changes that
> happened to scx200_acb was adding support for the newer CSxxxx chipsets,
> such as the one used with the geode LX (which does work now).

That ISA detection is almost definately suffering from severe bit rot.
Once you get past that though, you should be fine - the silicon behind
the ACB hasn't changed since the MediaGX days.

Jordan

-- 
Jordan Crouse
Senior Linux Engineer
Advanced Micro Devices, Inc.
<www.amd.com/embeddedprocessors>


