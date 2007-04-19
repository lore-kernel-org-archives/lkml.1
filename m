Return-Path: <linux-kernel-owner+w=401wt.eu-S1766844AbXDSQNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766844AbXDSQNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766843AbXDSQNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:13:40 -0400
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:42707 "EHLO
	ccerelbas02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766834AbXDSQNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:13:39 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] cciss: Fix warnings during compilation under 32bit environment
Date: Thu, 19 Apr 2007 16:12:49 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8CF462EE@G3W0639.americas.hpqcorp.net>
In-Reply-To: <1176995934.31764.7.camel@mulgrave.il.steeleye.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] cciss: Fix warnings during compilation under 32bit environment
thread-index: AceClhQJiIM+V4UoQ9izsZa98KjcoAAB096A
References: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2> <226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net> <1176995934.31764.7.camel@mulgrave.il.steeleye.com>
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "James Bottomley" <James.Bottomley@SteelEye.com>
Cc: "Hisashi Hifumi" <hifumi.hisashi@oss.ntt.co.jp>,
       <akpm@linux-foundation.org>, <jens.axboe@oracle.com>,
       <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
       "Cameron, Steve" <steve.cameron@hp.com>
X-OriginalArrivalTime: 19 Apr 2007 16:12:53.0199 (UTC) FILETIME=[95704DF0:01C7829D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Thursday, April 19, 2007 10:19 AM
> To: Miller, Mike (OS Dev)
> Cc: Hisashi Hifumi; akpm@linux-foundation.org; 
> jens.axboe@oracle.com; linux-kernel@vger.kernel.org; 
> linux-scsi@vger.kernel.org; Cameron, Steve
> Subject: RE: [PATCH] cciss: Fix warnings during compilation 
> under 32bit environment
> 
> On Thu, 2007-04-19 at 15:09 +0000, Miller, Mike (OS Dev) wrote:
> > Nak. You still haven't told where you saw these warnings. What 
> > compiler are you using? I do not see these in my 32-bit environment.
> 
> I think it's seen with CONFIG_LBD=n on 32 bits
> 
> In that configuration, sector_t is a u32 (it's u64 even on 32 
> bits with CONFIG_LBD=y).  The proposed code change is a 
> simple cut and paste from the sd driver.

Isn't there a better way than testing each one?

mikem

> 
> James
> 
> 
> 
