Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYKRWpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYKRWpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYKRWpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:45:38 -0500
Received: from ihemail4.lucent.com ([135.245.0.39]:42744 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYKRWpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:45:38 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Devices going offline on Adaptec 29320 using driver AIC79XX after messages "Attempting to queue an ABORT message:CDB"
Date: Tue, 18 Nov 2008 16:45:32 -0600
Message-ID: <CA39D769C8FE694788CE376026984BAB010BFE0E@ILEXC1U01.ndc.lucent.com>
In-Reply-To: <CA39D769C8FE694788CE376026984BAB010BFA89@ILEXC1U01.ndc.lucent.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Devices going offline on Adaptec 29320 using driver AIC79XX after messages "Attempting to queue an ABORT message:CDB"
Thread-Index: AclJm44yen2YAdEYSmyTX2+p3oxdWgAG3kew
References: <CA39D769C8FE694788CE376026984BAB010BFA89@ILEXC1U01.ndc.lucent.com>
From: "Rhine, Jay \(Jay\)" <jrhine@alcatel-lucent.com>
To: "Rhine, Jay \(Jay\)" <jrhine@alcatel-lucent.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Nov 2008 22:45:33.0536 (UTC) FILETIME=[5DABAE00:01C949CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>	I'm having a problem with the devices on my Adaptec 29320 cards.
>My best guess is this a bug in the AIC79XX (and possible AIX7XXX)
device driver, possibly releated to SMP.  However, I'm
>not really sure how to determine if that is really the case.
>
>	Here's the scenario. I have an IBM System X 3400 server with 3
Adaptec SCSI Cards - Adaptec 29320LPE PCIe Ultra320 
> SCSI adapter, Adaptec 29320ALP PCIx Ultra320 SCSI adapter, and Adaptec
2944 Ultra SCSI adapter (as well as some other
> cards unrelated to this problem - an LSI SAS Card, Emulex Fiber
Channel Card, an Intel SATA Controller, and an Intel 4
> Port Ethernet card).  The system has 2 Intel E5405 2.00GHz Quad-Core
processors.  I'm running Centos 5.2.  This system 
>is running in SMP mode.  I've seen this problem on the most recent
Centos5.2 kernels, 2.6.18-92.1.17.el5PAE and
> 2.6.18-92.1.13.el5PAE.  As of this morning, I'm on
2.6.18-92.1.18.el5PAE (so will see this issue there shortly).  The 
>logs in this email are from the 2.6.18-92.1.13.el5PAE kernel.

Okay, I just wanted to add that I've just verified that this problem
also occurs in 2.6.27 and 2.6.28-rc5.  I did not try 2.6.27.6 as there
are no changes in aic79xx driver between 2.6.27 and 2.6.27.6.  

Any thoughts?

Thanks,

Jay

