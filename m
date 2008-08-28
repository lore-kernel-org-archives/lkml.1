Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbYH1Jln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbYH1Jln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 05:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYH1Jld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 05:41:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:47469 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYH1Jlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 05:41:32 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: [ANNOUNCE] ACPI BIOS Guideline for Linux
Date: Thu, 28 Aug 2008 11:41:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200807241732.23412.trenn@suse.de> <200808272129.16131.carlos@strangeworlds.co.uk>
In-Reply-To: <200808272129.16131.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281141.30178.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 22:29:15 Carlos Corbacho wrote:
> On Thursday 24 July 2008 16:32:22 Thomas Renninger wrote:
> > \section{WMI - Windows Management Instrumentation}
> >
> > WMI is a Microsoft specific service. A small part of it
> > describes possible ACPI WMI implementations provided by the BIOS.
> > This is not part of the official ACPI specification and BIOS developers
> > should avoid using it. The Linux kernel driver supports basic WMI ACPI
> > functionality (since 2.6.25), but it is marked experimental.
> > ACPI functionality should not depend on the WMI interface.
>
> Perhaps it would be more useful to suggest to vendors/ BIOS writers what
> they should use here instead?

They can use their own devices.
There is a section about if you provide your own device, document it, etc.:

2 Vendor specific ACPI implementations
...
2. If new devices or functions are introduced, document how to use them. A
   short specification or a request for comments (RFC) can form the basis of
   a new standard which follows your needs.


But yes, it could be pointed out clearer.
I'll look closer at it when I touch it the next time.
Text snippets/suggestions are also appreciated.

Thanks,

     Thomas
