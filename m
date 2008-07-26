Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYGZMme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYGZMme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 08:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYGZMm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 08:42:26 -0400
Received: from mga10.intel.com ([192.55.52.92]:1602 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751818AbYGZMmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 08:42:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,255,1215414000"; 
   d="scan'208";a="364868804"
Message-ID: <488B1BB3.7010602@linux.intel.com>
Date: Sat, 26 Jul 2008 05:42:27 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Thomas Renninger <trenn@suse.de>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
 shutdown
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain> <200807251319.12786.trenn@suse.de> <200807251726.14366.rjw@sisk.pl>
In-Reply-To: <200807251726.14366.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If vendors use _OSI(Windows) to work around Windows bugs, we get broken
> automatically on those systems unless we put in some DMI-based hacks.

The general goal of ACPICA is to be bug-to-bug compatible with Windows.
So it might be needed for ACPICA to just emulate the respective bugs.

That said for this case I don't think that's needed, Linux just has to
detect the workarounds (which it already does I think)

-Andi

