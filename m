Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbYGYKop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbYGYKop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYGYKoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:44:34 -0400
Received: from mga10.intel.com ([192.55.52.92]:14473 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753674AbYGYKod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:44:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,252,1215414000"; 
   d="scan'208";a="364627717"
Message-ID: <4889AE93.4090601@linux.intel.com>
Date: Fri, 25 Jul 2008 03:44:35 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
 shutdown
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> Thomas,
> 
> re: OSI(Windows...)

Thomas,

I discussed this with Len here in Ottawa. First I fully agree with his 
reasoning for the current behaviour.

The main problem with OSI(Linux) is that it would be a quickly moving 
target so checking for it wouldn't really help the BIOSes.

Still there might be special cases where BIOSes will still check (e.g.
if they intend to work with specific distribution releases which might 
have specific bugs). Or to check for specific Linux features.

One way to do the later would be to define new OSI flags for specific
features. Haven't got a good proposal for that currently, but it's a 
possibility.

The other thing that could be done is to define OSI flags specific for
special distribution releases so BIOSes could potentially check for bugs
in SLED10 or RHWS5 or something like this, which are hopefully stable
in that behaviour doesn't move as quickly. The way to do that wouldn't
be to change the kernel though, but just specify them on the command 
line using acpi_osi=...

-Andi

