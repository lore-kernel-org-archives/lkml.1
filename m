Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbXB1EsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbXB1EsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 23:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbXB1EsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 23:48:01 -0500
Received: from mga03.intel.com ([143.182.124.21]:37277 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbXB1Er7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 23:47:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,228,1170662400"; 
   d="scan'208"; a="188110061:sNHT20495314"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/3]cpuidle take2: Core cpuidle infrastructure
Date: Tue, 27 Feb 2007 20:47:55 -0800
Message-ID: <EB12A50964762B4D8111D55B764A845401540255@scsmsx413.amr.corp.intel.com>
In-Reply-To: <20070227164427.GB2223@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3]cpuidle take2: Core cpuidle infrastructure
thread-index: AcdajpLXE4wIt0blRryQ0F6VcYNlgAAZJ6cQ
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Dave Jones" <davej@redhat.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, <linux-acpi@vger.kernel.org>,
       "Adam Belay" <abelay@novell.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       "Brown, Len" <len.brown@intel.com>
X-OriginalArrivalTime: 28 Feb 2007 04:47:58.0061 (UTC) FILETIME=[9E2C61D0:01C75AF3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Dave Jones [mailto:davej@redhat.com] 
>Sent: Tuesday, February 27, 2007 8:44 AM
>To: Pallipadi, Venkatesh
>Cc: linux-kernel; Andrew Morton; linux-acpi@vger.kernel.org; 
>Adam Belay; Li, Shaohua; Brown, Len
>Subject: Re: [PATCH 1/3]cpuidle take2: Core cpuidle infrastructure
>
>On Thu, Feb 22, 2007 at 01:52:57PM -0800, Venkatesh Pallipadi wrote:
>
> > Announcing 'cpuidle', a new CPU power management 
>infrastructure to manage
> > idle CPUs in a clean and efficient manner.
> > cpuidle separates out the drivers that can provide support 
>for multiple types
> > of idle states and policy governors that decide on what 
>idle state to use
> > at run time.
> > A cpuidle driver can support multiple idle states based on 
>parameters like
> > varying power consumption, wakeup latency, etc (ACPI 
>C-states for example).
> > A cpuidle governor can be usage model specific (laptop, server,
> > laptop on battery etc).
> > Main advantage of the infrastructure being, it allows 
>independent development
> > of drivers and governors and allows for better CPU power management.
>
>I played with this a little, and got puzzled.
>My quad core box used exactly the same amount of power whether the
>'ladder' governer was loaded & in use or not.  In both situations
>it was exactly the same as a vanilla 2.6.20
>
>I'd have expected it to use more until I loaded up 'ladder' to bring it
>on par featurewise with 2.6.20.  What did I miss?
>

Quad core what platform? How many C-states are supported in this
platform?

Current ladder is mostly like Policy embedded in ACPI today. But, Adam
has
been working on different policies that we want to experiment with as we
go along.

Thanks,
Venki
