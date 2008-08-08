Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYHLTz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYHLTz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYHLTzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:55:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbYHLTzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:55:12 -0400
Date: Fri, 8 Aug 2008 17:06:19 -0400
From: Dave Jones <davej@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: Regression in 2.6.27-rc2 in acpi_processor_init()
Message-ID: <20080808210619.GA4655@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Langsdorf, Mark" <mark.langsdorf@amd.com>,
	lkml <linux-kernel@vger.kernel.org>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Renninger <trenn@suse.de>
References: <6453C3CB8E2B3646B0D020C112613273C5AC59@sausexmb4.amd.com> <200808082302.11358.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808082302.11358.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 11:02:10PM +0200, Rafael J. Wysocki wrote:
 > [Adding CCs]
 > 
 > On Friday, 8 of August 2008, Langsdorf, Mark wrote:
 > > I got a regression when updated from 2.6.27-rc1 ro
 > > 2.6.27-rc2.  The noticeable symptom is the powernow-k8
 > > driver stopped working because the call to 
 > > acpi_processor_register_performance() is returning
 > > -EINVAL.
 > > 
 > > Digging into the code a bit more, that's occurring
 > > because acpi_processor_ppc_status is not set.
 > > That should be set in acpi_processor_init(), but
 > > that function is failing to register the ACPI
 > > processor driver.
 > > 
 > > I've dug through the code and can't see why 
 > > that call would fail.  It doesn't look like there
 > > were any changes between 2.6.27-rc1 and 2.6.27-rc2,
 > > but I may have missed something.
 > > 
 > > Any advice or suggestions in debugging this 
 > > appreciated.

a1531acd43310a7e4571d52e8846640667f4c74b perhaps related ?

	Dave

-- 
http://www.codemonkey.org.uk
