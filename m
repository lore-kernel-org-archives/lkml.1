Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbXKMPRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbXKMPRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXKMPRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:17:33 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:45216 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637AbXKMPRc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:17:32 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: powernow-k8 and non-standard multipliers
Date: Tue, 13 Nov 2007 09:06:16 -0600
Message-ID: <1449F58C868D8D4E9C72945771150BDF020770FF@SAUSEXMB1.amd.com>
In-Reply-To: <47393521.6060207@overt.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: powernow-k8 and non-standard multipliers
Thread-Index: AcgltZKJaEOyM8LrQVupuQENOlXccwAUOthg
References: <47393521.6060207@overt.org>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Philip Langdale" <philipl@overt.org>,
       "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 Nov 2007 15:06:17.0288 (UTC)
 FILETIME=[BD9CAC80:01C82606]
X-WSS-ID: 6B2762E307S2380191-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I've just upgraded to an X2 5000+ black edition. This model
> doesn't have a multiple lock and I tried bumping the multiplier
> up, which is perfectly stable, but which causes powernow-k8 to
> fail to load. I also tried with the updated patch you posted
> at the beginning of october (http://lkml.org/lkml/2007/10/9/224)
> which didn't make a difference.
> 
> Is it possible to make the driver work in this situation or does
> a non-standard multipler inherently mean that powernow stops
> working?

The standard PowerNow! driver, by design, will stop 
working in this situation.  I'm not going to support
a driver that allows non-standard multipliers because
it could cause a lot of hard to debug maintenance
issues.

-Mark Langsdorf
Operating System Research Center
AMD


