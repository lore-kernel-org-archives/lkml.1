Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbYJISkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbYJISkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYJISjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:39:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:43811 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbYJISjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:39:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,384,1220252400"; 
   d="scan'208";a="449163846"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
Date: Thu, 9 Oct 2008 11:39:09 -0700
Message-ID: <D936D925018D154694D8A362EEB0892005B12CD5@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20081009182809.GE6912@sequoia.sous-sol.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
Thread-Index: AckqPNZfOCrx0/rUS3+YXJvCaAvf5QAASEZQ
References: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com> <48EE3E71.8010604@goop.org> <20081009182809.GE6912@sequoia.sous-sol.org>
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: "Chris Wright" <chrisw@sous-sol.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <linux-kernel@vger.kernel.org>, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Chris Wright" <chrisw@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       <mingo@elte.hu>, <tytso@mit.edu>
X-OriginalArrivalTime: 09 Oct 2008 18:39:49.0769 (UTC) FILETIME=[692D5F90:01C92A3E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Chris Wright [mailto:chrisw@sous-sol.org]
> Sent: Thursday, October 09, 2008 11:28 AM
> 
> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> > Cihula, Joseph wrote:
> >> --- a/security/Kconfig	Mon Oct 06 12:50:47 2008 -0700
> >> +++ b/security/Kconfig	Tue Oct 07 00:13:02 2008 -0700
> >> @@ -115,6 +115,23 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
> >>  	  /proc/sys/vm/mmap_min_addr tunable.
> >>   +config TXT
> >
> > This should be X86_TXT; perhaps even X86_INTEL_TXT unless someone
else
> > is likely to implement this stuff.  ("TXT" is awfully generic.)
> 
> config NOTEPAD_EXE? (sorry, couldn't resist ;-)

Nobody in Linux-land uses the .txt file extension, so no conflicts,
right ;-)

We'll add some prefix for the next version, as Jeremy suggests.

> Is there anything for ia64?

Not at this time, but we're taking requests ;-)

Joe
