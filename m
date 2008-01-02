Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbYABX33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbYABX33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYABXYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:24:05 -0500
Received: from hqemgate02.nvidia.com ([216.228.112.143]:14406 "EHLO
	HQEMGATE02.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbYABXYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:24:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Wed, 02 Jan 2008 15:23:50 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: sata_nv + ADMA + Samsung disk problem
Date: Wed, 2 Jan 2008 15:23:26 -0800
Message-ID: <F72FA20C31DD4F4C997B91C5B3690A0950557D@hqemmail07.nvidia.com>
In-Reply-To: <477BDEA5.8040701@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: sata_nv + ADMA + Samsung disk problem
Thread-Index: AchNcV+2oUZO7rMYRimjKlyxu8kLaQAJFjFQ
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com> <477B0CFD.1030603@shaw.ca> <F72FA20C31DD4F4C997B91C5B3690A09505577@hqemmail07.nvidia.com> <477BDEA5.8040701@garzik.org>
From: "Allen Martin" <AMartin@nvidia.com>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: "Robert Hancock" <hancockr@shaw.ca>, "Tejun Heo" <htejun@gmail.com>,
       "Gabor Gombas" <gombasg@sztaki.hu>, <linux-kernel@vger.kernel.org>,
       <linux-ide@vger.kernel.org>, "Kuan Luo" <kluo@nvidia.com>,
       "Peer Chen" <pchen@nvidia.com>
X-OriginalArrivalTime: 02 Jan 2008 23:23:27.0057 (UTC) FILETIME=[7A31B410:01C84D96]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The software definitely provides that guarantee for all NCQ-capable 
> controllers.
> 

Well if that's not it, it must be some problem entering ADMA legacy
mode.  Here's what the Windows driver does:


ADMACtrl.aGO = 0
ADMACtrl.aEIEN = 0
poll {
  until ADMAStatus.aLGCY = 1 || timeout
}
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
