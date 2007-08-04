Return-Path: <linux-kernel-owner+w=401wt.eu-S1765016AbXHDUOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765016AbXHDUOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 16:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbXHDUOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 16:14:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbXHDUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 16:14:23 -0400
Message-ID: <46B4DE17.7070108@zytor.com>
Date: Sat, 04 Aug 2007 13:14:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: For discussion of SYSLINUX and tftp-hpa <syslinux@zytor.com>
CC: Andi Kleen <ak@suse.de>, Sahil Rihan <srihan@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [syslinux] Vmware crashes if compress/misc.c scrolls?
References: <4679BBCB.2000202@zytor.com> <46B40504.70208@vmware.com>	<200708041124.35526.ak@suse.de> <46B48ADF.9050006@vmware.com>
In-Reply-To: <46B48ADF.9050006@vmware.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> 
> It was 2.6.21.4, so it is fairly recent, but with 32-bit decompress 
> stage.  GCC was 4.2.0.
> 
> Sounds like a gcc bug, to me.
> 

I would argue that anything that causes a function and its callsite to
diverge, when they're part of the same file, is a gcc bug almost by
definition.

That doesn't mean it's not a problem and that there is not a solution --
if nothing else there should be a patch for -stable.

	-hpa
