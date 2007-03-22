Return-Path: <linux-kernel-owner+w=401wt.eu-S1030200AbXCVHdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200AbXCVHdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030201AbXCVHdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:33:15 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:14045 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030200AbXCVHdN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:33:13 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=wv8fG25YOP74GWMY9MYm2TqrSEv/vUph6BJyPpqXU9b1UbRI1e/jpkYZ6J4fBny1mrd/9qNh6Rg80+2ESDg9w3pRy9phPIZHfbMNkKp/6IRvPCX0+5NgTqM2x23/oOuR;
X-SBRSScore: None
X-IronPort-AV: i="4.14,311,1170630000"; 
   d="scan'208"; a="62721213:sNHT23614064"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: how can I touch softlockup watchdog on all cpus?
Date: Thu, 22 Mar 2007 08:33:05 +0100
Message-ID: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB710B@ABGEX01E.abg.fsc.net>
in-reply-to: <20070321164404.GF13218@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: how can I touch softlockup watchdog on all cpus?
Thread-Index: Acdr2CxsXMRHUjnjRKG3npj8G+U/aAAfAynw
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F2A@ABGEX01E.abg.fsc.net> <20070321164404.GF13218@redhat.com>
From: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Mar 2007 07:33:05.0371 (UTC) FILETIME=[547A6AB0:01C76C54]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You didn't explain _why_ you need to sleep for such a long time,
> and as you didn't give a pointer to your code, there's not
> much people can do to recommend changes other than "don't do that".

The code which is executed between the local_irq_disable and enable,
is just a function call into our companies bios (e.g. for updating itself)
and the long time is just 15 sec. while the bios has full control and OS is halted.
So I can't change anything at this point, but I need to fetch the watchdog,
cause it is not so nice, if there is a big BUG output on console while the
computer updates it's bios, very trustworthy isn't it :).

Ciao Thilo
@Dave: sorry that I send a direct mail :(
