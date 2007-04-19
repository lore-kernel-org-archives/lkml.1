Return-Path: <linux-kernel-owner+w=401wt.eu-S1766836AbXDSQFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766836AbXDSQFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766835AbXDSQFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:05:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766836AbXDSQFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:05:52 -0400
Message-ID: <46279358.1010002@redhat.com>
Date: Thu, 19 Apr 2007 12:05:44 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: PCI Express MMCONFIG and BIOS Bug messages..
References: <4626C514.5010605@shaw.ca>
In-Reply-To: <4626C514.5010605@shaw.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> I've seen a lot of systems (including brand new Xeon-based servers from
> IBM and HP) that output messages on boot like:
> 
> PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
> PCI: Not using MMCONFIG.
> 
> 
> So Microsoft is explicitly telling the BIOS developers that there is no
> need to reserve the MMCONFIG space in the E820 table because Windows
> doesn't care. On that basis it doesn't seem like a valid check to
> require it to be so reserved, then.
> 
> Really, I think we should be basing this check on whether the
> corresponding memory range is reserved in the ACPI resources, like
> Windows expects. This does require putting more fingers into ACPI from
> this early boot stage, though..
> 

Intel had posted patches to do exactly that, but they were rejected.
I don't remember why now...
