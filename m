Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYHHU7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYHHU7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYHHU7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:59:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42544 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbYHHU7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:59:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: Regression in 2.6.27-rc2 in acpi_processor_init()
Date: Fri, 8 Aug 2008 23:02:10 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "lkml" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <6453C3CB8E2B3646B0D020C112613273C5AC59@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC59@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808082302.11358.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs]

On Friday, 8 of August 2008, Langsdorf, Mark wrote:
> I got a regression when updated from 2.6.27-rc1 ro
> 2.6.27-rc2.  The noticeable symptom is the powernow-k8
> driver stopped working because the call to 
> acpi_processor_register_performance() is returning
> -EINVAL.
> 
> Digging into the code a bit more, that's occurring
> because acpi_processor_ppc_status is not set.
> That should be set in acpi_processor_init(), but
> that function is failing to register the ACPI
> processor driver.
> 
> I've dug through the code and can't see why 
> that call would fail.  It doesn't look like there
> were any changes between 2.6.27-rc1 and 2.6.27-rc2,
> but I may have missed something.
> 
> Any advice or suggestions in debugging this 
> appreciated.
> 
> -Mark Langsdorf
> Operating System Research Center
> AMD


