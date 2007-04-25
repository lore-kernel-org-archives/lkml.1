Return-Path: <linux-kernel-owner+w=401wt.eu-S2992565AbXDYK32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992565AbXDYK32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992572AbXDYK32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:29:28 -0400
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:9380 "EHLO
	dgate1.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992565AbXDYK30 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:29:26 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=CDmUGp0Ycv2VNCbLoMEkscpNr5nDx2ko84caDXci0XX9N+3CYfySJT+MLQUAe4pLB4efS7b/tijEpLjnXKlf4Z0rkvIHLUzGzlTs883nX/lKxB7P9ojeDAnIgmjHHAPL;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.14,450,1170630000"; 
   d="scan'208";a="72617841"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: NonExecutable Bit in 32Bit
Date: Wed, 25 Apr 2007 12:28:51 +0200
Message-ID: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF05302A20@ABGEX01E.abg.fsc.net>
In-Reply-To: <698310e10704250241k755c5438q93db6647181061e1@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: NonExecutable Bit in 32Bit
Thread-Index: AceHHfFxDkg05DvxTz6n0+0N/ftJmwABddpw
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net> <Pine.LNX.4.64.0704240640470.25153@server.thyself> <4ac8254d0704240046s23b2d349m2e0f0caa7eb95a91@mail.gmail.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF0530256E@ABGEX01E.abg.fsc.net> <4ac8254d0704242333g17972a7q2106015af946ea5@mail.gmail.com> <4ac8254d0704242337m518d87c3y8a26df66632ea6e4@mail.gmail.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF0530264B@ABGEX01E.abg.fsc.net> <698310e10704250241k755c5438q93db6647181061e1@mail.gmail.com>
From: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
To: "Marat Buharov" <marat.buharov@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Apr 2007 10:29:24.0580 (UTC) FILETIME=[98391A40:01C78724]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > And this prevents the lowmemory to be secured by NX?
> What do you mean, when you say "lowmemory"?

I mean EF-Segments. Cause we got a kernel oops as we accidentally used ioremap_nocache on a EF-Segment address.
Before that usage the EF-Segments weren't secured, afterwards they were.
We use now ioremap which does the high low mem check, but I was a bit confused that NX was not active before.
But I can't provide any further informations about the system, cause it was more or less support for a customer.

Ciao Thilo
