Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0BKNLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 08:11:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48159 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab0BKNLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:11:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the suspend tree
Date: Thu, 11 Feb 2010 14:11:35 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20100211171018.1011199f.sfr@canb.auug.org.au>
In-Reply-To: <20100211171018.1011199f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201002111411.35634.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 February 2010, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the suspend tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> drivers/usb/core/hcd-pci.c:138: warning: 'wait_for_companions' defined but not used
> 
> Introduced by commit ce74abf51a15ab82a9fae6dcd8a9c0038945f10e ("USB:
> implement non-tree resume ordering constraints for PCI host controllers").

Thanks for the info, I'll fix this up later today in my tree.

Rafael
