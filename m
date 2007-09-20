Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbXITSLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbXITSLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbXITSLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:11:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:28816 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbXITSLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:11:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,279,1186383600"; 
   d="scan'208";a="315438799"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: what is the difference between shutdown command and writing to /sys/power/state
Date: Thu, 20 Sep 2007 11:11:38 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD628ACF82B@scsmsx412.amr.corp.intel.com>
In-Reply-To: <200709200209.11331.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: what is the difference between shutdown command and writing to /sys/power/state
Thread-Index: Acf7I1asxyK7wUJCRke5OiwT0/Aj0gAjhUhA
References: <A3258B497F1C1441AD36A2E8B45FD628ACF018@scsmsx412.amr.corp.intel.com> <200709192334.30944.rjw@sisk.pl> <A3258B497F1C1441AD36A2E8B45FD628ACF21D@scsmsx412.amr.corp.intel.com> <200709200209.11331.rjw@sisk.pl>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Sep 2007 18:11:39.0913 (UTC) FILETIME=[B0E80F90:01C7FBB1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone tell me the flow of code for these two scenarios -
I write disk to /sys/power/state. How does system go to hibernation? How
does this trigger ACPI driver functions?
I issue shutdown command.
I am using 2.6.18 kernel.

Thanks,
Lomesh

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Rafael J.
Wysocki
Sent: Wednesday, September 19, 2007 5:09 PM
To: Agarwal, Lomesh
Cc: linux-kernel@vger.kernel.org
Subject: Re: what is the difference between shutdown command and writing
to /sys/power/state

On Wednesday, 19 September 2007 23:37, Agarwal, Lomesh wrote:
> Can you tell me the differences?
> Also what do you mean by - depending also on what you mean by 'now'? I

Please tell me what kernel version you're referring to.

> gave now as a time parameter to shutdown command. How can it be
> interpreted in a different way?

Sorry, I have misunderstood your post (the "now" doesn't look as a part
of the
command).

Greetings,
Rafael


> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
> Sent: Wednesday, September 19, 2007 2:35 PM
> To: Agarwal, Lomesh
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: what is the difference between shutdown command and
writing
> to /sys/power/state
> 
> On Wednesday, 19 September 2007 20:50, Agarwal, Lomesh wrote:
> > Does linux handles writing "disk" to /sys/power/state and shutdown
-P
> > now differently (except writing to disk part)?
> 
> Yes, it does (depending also on what you mean by 'now').
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
