Return-Path: <linux-kernel-owner+w=401wt.eu-S1751560AbXCDKbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbXCDKbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 05:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXCDKbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 05:31:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:13422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbXCDKbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 05:31:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,246,1170662400"; 
   d="scan'208"; a="52849529:sNHT18714348"
Message-ID: <45EAA003.7020504@linux.intel.com>
Date: Sun, 04 Mar 2007 13:31:31 +0300
From: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc1: more ACPI errors (EC__)
References: <Pine.SOC.4.64.0702260842260.9705@math>
In-Reply-To: <Pine.SOC.4.64.0702260842260.9705@math>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos wrote:
> I tested 2.6.21-rc1 on my laptop (IBM X20 with 440BX) and found two 
> problems:
>
> First, a seemingly harmless one - ACPI error messages during bootup:
>
> ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for [EmbeddedControl] [20070126]
> ACPI Exception (dswexec-0462): AE_NOT_FOUND, While resolving operands for [OpcodeName unavailable] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.ISA_.EC__.BAT0._STA] (Node d3c435e0), AE_NOT_FOUND
> ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for [EmbeddedControl] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.ISA_.EC__.AC__._PSR] (Node d3c43540), AE_NOT_FOUND
> ACPI Exception (ac-0095): AE_NOT_FOUND, Error reading AC Adapter state [20070126]
>
> And second, there were ACPI error messages about EC__ during shutdown. 
> These messages appeared, then the "acpi_power_off called" message 
> appeared, then it waited for about 5 seconds (this does not happen 
> normally) and then it succeeded shutting down. Captured a screenshot of 
> these messages, temporarily available at 
> http://www.cs.ut.ee/~mroos/x20-shutdown-acpi-errors.jpg
>
>   
please take a look at 8066 bug and patches there.

regards,
    alex
