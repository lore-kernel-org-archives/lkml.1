Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbXLMDKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbXLMDKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 22:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXLMDKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 22:10:22 -0500
Received: from hqemgate02.nvidia.com ([216.228.112.143]:12901 "EHLO
	HQEMGATE02.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbXLMDKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 22:10:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Wed, 12 Dec 2007 19:10:19 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [PATCH] sata_nv,adma: fix error when rmmod sata_nv
Date: Thu, 13 Dec 2007 11:10:05 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AAC@hkemmail01.nvidia.com>
In-Reply-To: <475F994B.9090505@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] sata_nv,adma: fix error when rmmod sata_nv
Thread-Index: Acg8l50UcQunylQ2TUmbbBrRg1OXbQAnKQ9A
References: <200709251323031982245@gmail.com> <470FE47B.5060505@garzik.org> <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com> <47181CE1.4000802@garzik.org> <cfaab6210710182358t4de355f9wd6d605a7b8076ace@mail.gmail.com> <47185BFD.2010909@garzik.org> <cfaab6210710211855q7a2de35co13d3017b2a07d4cc@mail.gmail.com> <47352DD8.6040607@garzik.org> <47353AE8.5050900@garzik.org> <4735FFE6.6020705@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1BFE2AAB@hkemmail01.nvidia.com> <475F994B.9090505@gmail.com>
From: "Kuan Luo" <kluo@nvidia.com>
To: "Tejun Heo" <htejun@gmail.com>
Cc: "Jeff Garzik" <jeff@garzik.org>, "peer chen" <peerchen@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "Robert Hancock" <hancockr@shaw.ca>
X-OriginalArrivalTime: 13 Dec 2007 03:10:06.0811 (UTC) FILETIME=[A99ABAB0:01C83D35]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo  wrote:
> Which kernel version are you using?  The following commit should have
> fixed the problem.  Please give a shot at 2.6.24-rc5.  Thanks.
> 
> commit 32ebbc0c0d5d18c0135b55d1eb0029f48c54aff0
> Author: Tejun Heo <htejun@gmail.com>
> Date:   Thu Nov 8 13:09:00 2007 +0900
> 
> libata: port and host should be stopped before hardware resources are
> released
> 
> -- 
> tejun
> 
I have seen your commit. And i apologize for not updating the newest
kernel.
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
