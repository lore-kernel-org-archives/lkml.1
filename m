Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYKSOFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYKSOFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbYKSOFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:05:37 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:16264 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYKSOFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:05:35 -0500
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Bernhard Walle <bwalle@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "wim@iguana.be" <wim@iguana.be>,
       "stable@kernel.org" <stable@kernel.org>
Date: Wed, 19 Nov 2008 14:05:06 +0000
Subject: RE: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as
 executable
Thread-Topic: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space
 as executable
Thread-Index: AclJzY3QRPv5jMBOT3SLNsoJ2hn4dQAggSEg
Message-ID: <183C1D5A376DE343AA8F94FC2A1EC1493AA5CEE7AB@GVW1091EXB.americas.hpqcorp.net>
References: <1226674023-5374-1-git-send-email-bwalle@suse.de>
	<20081118143015.72af31d3.akpm@linux-foundation.org>
 <20081118233229.294270fb@kopernikus.site>
In-Reply-To: <20081118233229.294270fb@kopernikus.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have also verified that returning NOTIFY_OK from the hpwdt_pretimeout routine makes the KDUMP feature work correctly.

Bernhard pointed that out a week or so ago and we have since verified it.


Thanks,

Tom


-----Original Message-----
From: Bernhard Walle [mailto:bwalle@suse.de]
Sent: Tuesday, November 18, 2008 4:32 PM
To: Andrew Morton
Cc: Mingarelli, Thomas; linux-kernel@vger.kernel.org; wim@iguana.be; stable@kernel.org
Subject: Re: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as executable

* Andrew Morton [2008-11-18 14:30]:
>
> This is also needed in 2.6.27.x, yes?

Right. But I was waiting for feedback from the author since I'm really
not familiar with low level memory management and that driver. :(


Regards,
Bernhard
