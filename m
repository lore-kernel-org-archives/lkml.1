Return-Path: <linux-kernel-owner+w=401wt.eu-S934112AbXCVQqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbXCVQqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934118AbXCVQqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:46:30 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:13918 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934112AbXCVQq3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:46:29 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=QlaNOH5vEJps+CZeAhU6x+wwFZ3vTQFd/3s+8DhNj5CvC4nZB0to3VZadnZJOR6XKyNMCsw96Di2YztE3IdKcDYofPAOHXSsSEJL5q9uQtMGFvHUsouNwhofQNtQrpMR;
X-SBRSScore: None
X-IronPort-AV: i="4.14,315,1170630000"; 
   d="scan'208"; a="62810818:sNHT2033884728"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: how can I touch softlockup watchdog on all cpus?
Date: Thu, 22 Mar 2007 17:46:15 +0100
Message-ID: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB0F5@ABGEX01E.abg.fsc.net>
in-reply-to: <75b66ecd0703220917w2fa7c6afs4817b689f8a2e98f@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: how can I touch softlockup watchdog on all cpus?
Thread-Index: Acdsnafm8k5LaMq1RXmhglz7qXIVoQAAz6jg
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F2A@ABGEX01E.abg.fsc.net> <20070321164404.GF13218@redhat.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB710B@ABGEX01E.abg.fsc.net> <75b66ecd0703220830wdb4a612u86c80e71d4918cc4@mail.gmail.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB060@ABGEX01E.abg.fsc.net> <75b66ecd0703220917w2fa7c6afs4817b689f8a2e98f@mail.gmail.com>
From: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Mar 2007 16:46:20.0249 (UTC) FILETIME=[9E2AD490:01C76CA1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sounds like you have a fundamentally incompatible set of requirements.

Sounds so yep :)

> Why do you need the softlockup watchdog if you intend to induce soft
> lockups on purpose?

It's a condition of a customer of us, so I can't change it.

But it happens not often that my part is used. So I thought there is a mechanism to disable or reset the watchdog
because it is a legal pause for it. And there is one "touch_softlockup_watchdog()", that does what I want,
BUT just for the current cpu. And so the watchdog blats from the other cpu.

Thilo
