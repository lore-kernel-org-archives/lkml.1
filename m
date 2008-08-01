Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbYHAVIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbYHAVIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759957AbYHAVHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:07:55 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:60444 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759976AbYHAVHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:07:54 -0400
Date: Fri, 01 Aug 2008 17:07:48 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
 shutdown
In-reply-to: <alpine.LFD.1.10.0807261311420.2958@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Message-id: <alpine.LFD.1.10.0808011707270.3011@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200807241727.41715.trenn@suse.de>
 <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain>
 <488A4F70.4010208@tremplin-utc.net>
 <alpine.LFD.1.10.0807261311420.2958@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend of a message that didn't hit the list]

On Sat, 26 Jul 2008, Len Brown wrote:

> 
> 
> On Sat, 26 Jul 2008, Eric Piel wrote:
> 
> > Just out of curiosity, let's imagine that today HP decides to fix its BIOS.
> > What would be the way to do it? Of course, without putting additional problems
> > when Windows is booted.
> 
> The should return a valid temperature from _CRT,
> and that should work everyplace without any check for OS version.
> 
> We know that this must work, because plenty of Vista compatible
> platforms do it -- such as the T61 that I'm typing on.
> 
> ie. we really don't know why HP returned _CRT=0 for vista in this BIOS,
> we just assume that it didn't cause anything bad to happen.
> 
> -Len
> 
> 
