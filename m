Return-Path: <linux-kernel-owner+w=401wt.eu-S932515AbXB1WPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbXB1WPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbXB1WPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:15:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:25901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbXB1WP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:15:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,232,1170662400"; 
   d="scan'208"; a="51787329:sNHT20320182"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.21-rc1: more ACPI errors (EC__)
Date: Wed, 28 Feb 2007 14:14:40 -0800
Message-ID: <B28E9812BAF6E2498B7EC5C427F293A401FEFC82@orsmsx415.amr.corp.intel.com>
In-Reply-To: <Pine.SOC.4.64.0702260842260.9705@math>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.21-rc1: more ACPI errors (EC__)
Thread-Index: AcdasPWefseR1eR7RAy4wa9MDjcq0wA1NeCw
From: "Moore, Robert" <robert.moore@intel.com>
To: "Meelis Roos" <mroos@linux.ee>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       <linux-acpi@vger.kernel.org>
X-OriginalArrivalTime: 28 Feb 2007 22:14:41.0402 (UTC) FILETIME=[D7E1B5A0:01C75B85]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This exception appears to be originating somewhere in the EC driver:

ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for
[EmbeddedControl] [20070126]



> -----Original Message-----
> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
> owner@vger.kernel.org] On Behalf Of Meelis Roos
> Sent: Tuesday, February 27, 2007 12:50 PM
> To: Linux Kernel list; linux-acpi@vger.kernel.org
> Subject: 2.6.21-rc1: more ACPI errors (EC__)
> 
> I tested 2.6.21-rc1 on my laptop (IBM X20 with 440BX) and found two
> problems:
> 
> First, a seemingly harmless one - ACPI error messages during bootup:
> 
> ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for
> [EmbeddedControl] [20070126]
> ACPI Exception (dswexec-0462): AE_NOT_FOUND, While resolving operands
for
> [OpcodeName unavailable] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.ISA_.EC__.BAT0._STA] (Node d3c435e0), AE_NOT_FOUND
> ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for
> [EmbeddedControl] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.ISA_.EC__.AC__._PSR] (Node d3c43540), AE_NOT_FOUND
> ACPI Exception (ac-0095): AE_NOT_FOUND, Error reading AC Adapter state
> [20070126]
> 
> And second, there were ACPI error messages about EC__ during shutdown.
> These messages appeared, then the "acpi_power_off called" message
> appeared, then it waited for about 5 seconds (this does not happen
> normally) and then it succeeded shutting down. Captured a screenshot
of
> these messages, temporarily available at
> http://www.cs.ut.ee/~mroos/x20-shutdown-acpi-errors.jpg
> 
> --
> Meelis Roos (mroos@linux.ee)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
