Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbYI2Pca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbYI2Pca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYI2PcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:32:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:4639 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYI2PcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:32:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,332,1220252400"; 
   d="scan'208";a="341809658"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>
CC: Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>
Date: Mon, 29 Sep 2008 08:32:10 -0700
Subject: RE: Use CPUID to communicate with the hypervisor.
Thread-Topic: Use CPUID to communicate with the hypervisor.
Thread-Index: AckiBkBz0YQD2bo+RlaCKKnqGOt5ggAQQnMQ
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A15726DBE3@orsmsx505.amr.corp.intel.com>
References: <1222472815.29886.43.camel@alok-dev1>
 <20080929065557.GB9952@redhat.com> <48E085B3.1080507@redhat.com>
In-Reply-To: <48E085B3.1080507@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/29/2008 12:37:23 AM, Avi Kivity wrote:
> Gleb Natapov wrote:
> > Can this interface be used to pass variable sized data from a
> > hypervisor to a gust? ACPI or DMI tables for instance.
> >
>
> In theory it can, but it would be a bad idea.  cpuid is best used to
> communicate cpu features; ACPI and DMI are (mostly) system features.

Also, we have reserved the MSRs from 0x40000000 - 0x400000FF for software use. We could use such MSRs, but what's the benefits of using those when ACPI already defined the detection mechanism?

             .
Jun Nakajima | Intel Open Source Technology Center
