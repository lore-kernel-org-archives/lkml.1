Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYAGFdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYAGFdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 00:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYAGFc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 00:32:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.112.152]:7265 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYAGFc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 00:32:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Sun, 06 Jan 2008 21:32:50 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [PATCH] msi: set 'En' bit of MSI Mapping Capability
Date: Mon, 7 Jan 2008 13:32:28 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1FD7D6B5@hkemmail01.nvidia.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] msi: set 'En' bit of MSI Mapping Capability
Thread-Index: AchGIxCwaS2ghDupTG+xhYihZwo7dgHAmXLAAPI1AWA=
References: <200712182300373901202@gmail.com><m14pefaclv.fsf@ebiederm.dsl.xmission.com><15F501D1A78BD343BE8F4D8DB854566B1F24C119@hkemmail01.nvidia.com><m1d4t17zkn.fsf@ebiederm.dsl.xmission.com><15F501D1A78BD343BE8F4D8DB854566B1F571D0F@hkemmail01.nvidia.com> <m1lk7kl3de.fsf@ebiederm.dsl.xmission.com> 
From: "Peer Chen" <pchen@nvidia.com>
To: "Peer Chen" <pchen@nvidia.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "peerchen" <peerchen@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "Andy Currid" <ACurrid@nvidia.com>
X-OriginalArrivalTime: 07 Jan 2008 05:32:43.0199 (UTC) FILETIME=[B9EFACF0:01C850EE]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,
Any decision for this patch, if not, currently we prefer to add all our
code to quirks.c.

BRs
Peer Chen

-----Original Message-----
From: Peer Chen 
Sent: Wednesday, January 02, 2008 5:58 PM
To: 'Eric W. Biederman'
Cc: peerchen; linux-kernel; akpm; Andy Currid
Subject: RE: [PATCH] msi: set 'En' bit of MSI Mapping Capability

I think it's more reasonable to only apply this rule onto AMD platform.

BRs
Peer Chen

-----Original Message-----
From: Eric W. Biederman [mailto:ebiederm@xmission.com] 
Sent: Monday, December 24, 2007 7:49 PM
To: Peer Chen
Cc: peerchen; linux-kernel; akpm; Andy Currid
Subject: Re: [PATCH] msi: set 'En' bit of MSI Mapping Capability

"Peer Chen" <pchen@nvidia.com> writes:

> I feel it's dangerous to set the En bit on Intel platform, If the HT
MSI
> En is set, the MSI should be expected to transform to HT INT message
> format. It may cause interrupt lost or hardware internal state machine
> failed depend on the hardware design.

Reasonable.  As long as what the quirk is to avoid errata and
chipset specific issues I don't have a problem with it.

I figure the quirk should be a separate patch though.

My concern is that the general rule that always enabling HT MSI
mapping capabilities is reasonable.  Even if there are some
specific exceptions where we don't want to do that.

I want code that requires the smallest list of chipset
exceptions that we can make. 

Eric
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
