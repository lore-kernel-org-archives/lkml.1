Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbXD0B1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbXD0B1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbXD0B1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:27:32 -0400
Received: from hqemgate02.nvidia.com ([216.228.112.143]:1729 "EHLO
	HQEMGATE02.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbXD0B1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:27:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] drivers/net: move the nvidia forcedeth driver from 100M group to 1000M group
Date: Fri, 27 Apr 2007 09:27:18 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B07FC61B5@hkemmail01.nvidia.com>
In-Reply-To: <20070425140629.GD5577@csclub.uwaterloo.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net: move the nvidia forcedeth driver from 100M group to 1000M group
Thread-Index: AceHQvXnXZ9ND/SjQLeoPCJkqTM0GQBJPXPg
From: "Peer Chen" <pchen@nvidia.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Cc: <linux-kernel@vger.kernel.org>, <akpm@osdl.org>, <torvalds@osdl.org>
X-OriginalArrivalTime: 27 Apr 2007 01:27:18.0916 (UTC) FILETIME=[323E2440:01C7886B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You are right,both ways would cause confusion,but sooner or later we need to move it because our NICs onward are all Gigabit and 100M NICs will disappear gradually in the future. Probably H.Peter's suggestion that have a single list for 100M and 1000M is a better choice.

-----Original Message-----
From: Lennart Sorensen [mailto:lsorense@csclub.uwaterloo.ca] 
Sent: Wednesday, April 25, 2007 10:06 PM
To: Peer Chen
Cc: linux-kernel@vger.kernel.org; akpm@osdl.org; torvalds@osdl.org
Subject: Re: [PATCH] drivers/net: move the nvidia forcedeth driver from 100M group to 1000M group

On Wed, Apr 25, 2007 at 01:30:04PM +0800, Peer Chen wrote:
> nForce ehternet is a Gigabit NIC not 100M, move it to 1000M group to 
> avoid the confusion.

The forcedeth on my nforce2 board is 100Mbit.  I think the driver handles both 100Mbit and GBit type devices.  Makes for an interesting categorization problem.  Moving it would cause confusion.  Leaving it where it is could cause confusion.  Moving it may confuse existing users more though so I would recommend leaving it alone unless you can somehow make it appear in both.

--
Len Sorensen
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
