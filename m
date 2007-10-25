Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbXJYW3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbXJYW3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbXJYW3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:29:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49212 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbXJYW3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:29:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Opteron box and 4Gb memory
Date: Fri, 26 Oct 2007 00:45:43 +0200
User-Agent: KMail/1.9.5
Cc: "J.A. Magallon" <magallon@unizar.es>,
       "Linux-Kernel, " <linux-kernel@vger.kernel.org>
References: <20071025230904.03d5f46a@werewolf> <47211172.9070606@zytor.com>
In-Reply-To: <47211172.9070606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260045.44090.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 25 October 2007 23:58, H. Peter Anvin wrote:
> J.A. Magallon wrote:
> > Hi...
> > 
> > I have some Quad-Opteron boxes with 4Gb memory and two of them are
> > running two different Linux distros.
> > 
> > Box one sees 4Gb of memory, but box two just sees 3.
> > Their mtrr setups are different:
> > 
> > Why ? Is it a bios setup problem ? A kernel problem ?
> > grep HIGHMEN in configs for both kernels does not give anything, so
> > I still understand less this thing...
> > 
> 
> It would depend on how the BIOS programmed the memory controllers.  For 
> 32-bit (and lots of device) compatibility, a memory hole is required 
> below 4 GB.  Not all memory controllers can remap memory in the 3-4 GB 
> range above the 4 GB memory; I'm not sure if that varies with the 
> different Opteron processors.

It shouldn't, AFAICS.

Greetings,
Rafael
