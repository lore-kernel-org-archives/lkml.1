Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZIPTcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZIPTcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbZIPTcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:32:00 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37289 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbZIPTcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:32:00 -0400
Date: Wed, 16 Sep 2009 15:31:37 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Nelson Elhage <nelhage@ksplice.com>
Subject: Re: [PATCH v2 2/2] arm: Clean up linker script using new linker
 script macros.
In-Reply-To: <20090916191928.GC16457@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.1.10.0909161522510.2942@dr-wily.mit.edu>
References: <1253119195-19056-1-git-send-email-tabbott@ksplice.com> <1253119195-19056-3-git-send-email-tabbott@ksplice.com> <20090916191928.GC16457@n2100.arm.linux.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Russell King - ARM Linux wrote:

> On Wed, Sep 16, 2009 at 12:39:55PM -0400, Tim Abbott wrote:
> > This patch is mostly a straightforward translation. The primary side
> > effect to the resulting vmlinux should be to increase the alignment on
> > the initramfs to the standard PAGE_SIZE from 32 bytes.
> 
> I notice you're not sending this to the ARM lists, which means it's
> not getting a full review (eg, by Nico who knows the XIP issues in
> here).  Are you sure this is correct for both the XIP and non-XIP
> cases?

I can resend to the ARM lists if it will work -- I didn't do so this time 
because I seem to recall that only subscribers can post; maybe I 
misunderstood the MAINTAINERS entry?

L:      linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)

Looking at the code, there's definitely something wrong in relation to 
CONFIG_XIP_KERNEL; I'll fix this and repost CCing 
linux-arm-kernel@lists.arm.linux.org.uk.

	-Tim Abbott
