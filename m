Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYAJVK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYAJVK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYAJVKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:10:19 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:53589 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbYAJVKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:10:17 -0500
Date: Thu, 10 Jan 2008 21:57:27 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Nathan Grennan <alistair@cygnusx-1.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: r8169 and out of space
Message-ID: <20080110205727.GA8692@electric-eye.fr.zoreil.com>
Mail-Followup-To: Francois Romieu <romieu@fr.zoreil.com>,
	Alistair John Strachan <alistair@devzero.co.uk>,
	Nathan Grennan <alistair@cygnusx-1.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-net@vger.kernel.org
References: <478655B6.6010406@cygnusx-1.org> <200801101920.47041.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801101920.47041.alistair@devzero.co.uk>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan <alistair@devzero.co.uk> :
[..]
> No, we have not diagnosed the cause of the problem, beyond the swiotlb usage. 
> I'm adding the r8169 maintainer, linux-net and linux-kernel to CC, to pass on 
> your information, I hope you don't mind.

swiotlb fragmentation perhaps ?

Switching the driver to be page based on Rx would help then.

[...]
> >   I have a Abit AB9 Pro motherboard with Intel P965 chipset, 4gb of
> > memory, and two onboard r8169.

Which r8169 model exactly ?

-- 
Ueimor
