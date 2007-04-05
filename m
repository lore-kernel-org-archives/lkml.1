Return-Path: <linux-kernel-owner+w=401wt.eu-S1767022AbXDEOq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767022AbXDEOq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767016AbXDEOq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:46:27 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:23963 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767022AbXDEOq0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:46:26 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] x86: limit mwait_idle to Intel CPUs
Date: Thu, 5 Apr 2007 09:46:10 -0500
Message-ID: <1449F58C868D8D4E9C72945771150BDFD967EA@SAUSEXMB1.amd.com>
In-Reply-To: <200704051624.45747.ak@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86: limit mwait_idle to Intel CPUs
Thread-Index: Acd3jnIP95PvN1kZSjqphzjsxODKKQAApNjQ
References: <20070405140045.GN6356@alberich.amd.com>
 <200704051624.45747.ak@suse.de>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Andi Kleen" <ak@suse.de>,
       "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
cc: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 05 Apr 2007 14:46:10.0861 (UTC)
 FILETIME=[26D205D0:01C77791]
X-WSS-ID: 6A0BD4393283272507-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Commit 991528d7348667924176f3e29addea0675298944
> > introduced mwait_idle which is supposed to work
> > for Intel CPUs starting with Core Duo.
> > 
> > AMD Fam10 processors won't enter C1 on mwait.
> 
> Unfortunate. Will this be fixed?

Fam10 processors were not designed to enter C1 on mwait.
That feature will not be added for Fam10 processors.
 
-Mark Langsdorf
Operating Systems Research Center
AMD, Inc.


