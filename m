Return-Path: <linux-kernel-owner+w=401wt.eu-S932502AbXH3OtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbXH3OtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXH3Osw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:48:52 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:34264 "EHLO
	outbound5-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756855AbXH3Osv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:48:51 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Thu, 30 Aug 2007 08:48:09 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Andres Salomon" <dilinger@queued.net>
cc: jayakumar.alsa@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
Subject: Re: ALSA: cs5535audio fixes
Message-ID: <20070830144809.GM5851@cosmic.amd.com>
References: <20070829232745.5ea9ff3e.dilinger@queued.net>
MIME-Version: 1.0
In-Reply-To: <20070829232745.5ea9ff3e.dilinger@queued.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 30 Aug 2007 14:47:02.0171 (UTC)
 FILETIME=[A0208EB0:01C7EB14]
X-WSS-ID: 6AC8071C0X86134502-07-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/07 23:27 -0400, Andres Salomon wrote:
> Hi,
> 
> Here are a bunch of fixes for the cs5535audio driver.  None of these are
> OLPC specific; generic chip and power management fixes, and one cleanup
> patch.  All have been tested on an OLPC (5536), so even though the 5535
> data sheet claims to be the same, it would be nice to hear success/failure
> reports from someone with a 5535.

These look good - and they should work fine on the 5535 - none of the patches
really change how we touch the hardware, just when we touch the hardware.

5536 is by far the more popular chip now, so I recommend we put these in,
and if by some unlucky coincidence a 5535 bug pops up, we'll deal with it
when it happens.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


