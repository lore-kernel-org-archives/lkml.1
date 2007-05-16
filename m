Return-Path: <linux-kernel-owner+w=401wt.eu-S965880AbXEPVoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965880AbXEPVoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965271AbXEPVoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:44:14 -0400
Received: from 203-97-71-235.dsl.clear.net.nz ([203.97.71.235]:62173 "EHLO
	gazelle.ad.endace.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965158AbXEPVoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:44:13 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
Date: Thu, 17 May 2007 09:44:10 +1200
Message-ID: <659F626D666070439A4A5965CD6EBF406B3327@gazelle.ad.endace.com>
In-Reply-To: <Pine.LNX.4.64.0705161058430.1280@asgard.lang.hm>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Software raid0 will crash the file-system, when each disk is 5TB
Thread-Index: AceX5Uc3Dy9Im9CNRnOxD/rModHfwAAHd86w
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com> <20070516140452.GC5286@schatzie.adilger.int> <Pine.LNX.4.64.0705161058430.1280@asgard.lang.hm>
From: "Jeff Zheng" <Jeff.Zheng@endace.com>
To: <david@lang.hm>, "Andreas Dilger" <adilger@clusterfs.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
You will definitely meet the same problem. As very large hardware disk
becomes more and more popular, this will become a big issue for software
raid. 


Jeff

-----Original Message-----
From: david@lang.hm [mailto:david@lang.hm] 
Sent: Thursday, 17 May 2007 6:04 a.m.
To: Andreas Dilger
Cc: Jeff Zheng; linux-kernel@vger.kernel.org;
linux-fsdevel@vger.kernel.org
Subject: Re: Software raid0 will crash the file-system, when each disk
is 5TB


my experiance is taht if you don't have CONFIG_LBD enabled then the
kernel will report the larger disk as 2G and everything will work, you
just won't get all the space.

plus he seems to be crashing around 500G of data

and finally (if I am reading the post correctly) if he configures the
drives as 4x2.2TB=11TB instead of 2x5.5TB=11TB he doesn't have the same
problem.

I'm getting ready to setup a similar machine that will have 3x10TB (3 15
disk arrays with 750G drives), but won't be ready to try this for a few
more days.

David Lang
