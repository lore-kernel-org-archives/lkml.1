Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXEPVmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXEPVmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760381AbXEPVmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:42:36 -0400
Received: from 203-97-71-235.dsl.clear.net.nz ([203.97.71.235]:62021 "EHLO
	gazelle.ad.endace.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759818AbXEPVmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:42:35 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
Date: Thu, 17 May 2007 09:42:33 +1200
Message-ID: <659F626D666070439A4A5965CD6EBF406B3324@gazelle.ad.endace.com>
In-Reply-To: <Pine.LNX.4.61.0705162016060.9019@yvahk01.tjqt.qr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Software raid0 will crash the file-system, when each disk is 5TB
Thread-Index: AceX5sBqavNueZvmT42IsTccYenyHQAHDAXA
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com> <20070516140452.GC5286@schatzie.adilger.int> <Pine.LNX.4.64.0705161058430.1280@asgard.lang.hm> <Pine.LNX.4.61.0705162016060.9019@yvahk01.tjqt.qr>
From: "Jeff Zheng" <Jeff.Zheng@endace.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>, <david@lang.hm>
Cc: "Andreas Dilger" <adilger@clusterfs.com>, <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Problem is that is only happens when you actually write data to the
raid. You need the actual space to reproduce the problem.

Jeff 

-----Original Message-----
From: Jan Engelhardt [mailto:jengelh@linux01.gwdg.de] 
Sent: Thursday, 17 May 2007 6:17 a.m.
To: david@lang.hm
Cc: Andreas Dilger; Jeff Zheng; linux-kernel@vger.kernel.org;
linux-fsdevel@vger.kernel.org
Subject: Re: Software raid0 will crash the file-system, when each disk
is 5TB


On May 16 2007 11:04, david@lang.hm wrote:
>
> I'm getting ready to setup a similar machine that will have 3x10TB (3 
> 15 disk arrays with 750G drives), but won't be ready to try this for a
few more days.

You could emulate it with VMware. Big disks are quite "cheap" when they
are not allocated.


	Jan
-- 
