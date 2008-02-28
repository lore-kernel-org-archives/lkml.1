Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbYB1CnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbYB1CnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 21:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYB1Cm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 21:42:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:56521 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbYB1Cm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 21:42:57 -0500
Subject: Re: [PATCH 1/2] firewire: endianess fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       Jarod Wilson <jwilson@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <tkrat.9e19fa31951506af@s5r6.in-berlin.de>
References: <20080220220326.GA22328@uranus.ravnborg.org>
	 <1203545913.25307.47.camel@brick>
	 <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de>
	 <tkrat.9e19fa31951506af@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 13:41:46 +1100
Message-Id: <1204166506.15052.336.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-23 at 12:24 +0100, Stefan Richter wrote:
> The generation of incoming requests was filled in in wrong byte order on
> machines with big endian CPU.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: sparclinux@vger.kernel.org
> Cc: linuxppc-dev@ozlabs.org
> ---
> 
> This patch is a shot in the dark, based on a warning when building with
> C=1 CHECKFLAGS="-D__CHECK_ENDIAN__".  Is it really a fix, or was the
> previous code accidentally correct?
> 
> This needs to be tested on different big endian PCs, if possible with
> the Apple Uninorth FireWire controller and other types of controllers.
> One test which involves ohci->request_generation is simply with an SBP-2
> device (harddisk, CD-ROM...).  Does SBP-2 login etc. work?

Do we have the workaround for the old Apple UniNorth in the new FW OHCI
driver (for selfID swapping iirc ?)

There are several variants of Apple OHCI's here, but afaik only one with
a "problem".

Cheers,
Ben.


