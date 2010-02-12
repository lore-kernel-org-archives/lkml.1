Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab0BLLcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:32:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53259 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab0BLLcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:32:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the suspend tree
Date: Fri, 12 Feb 2010 12:32:45 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20100212155750.3f95932f.sfr@canb.auug.org.au>
In-Reply-To: <20100212155750.3f95932f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201002121232.45343.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 February 2010, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the suspend tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> drivers/usb/core/hcd-pci.c:153: warning: return type defaults to 'int'
> drivers/usb/core/hcd-pci.c: In function 'clear_hs_companion':
> drivers/usb/core/hcd-pci.c:153: warning: control reaches end of non-void function
> 
> Introduced by commit 708efd3eb95d318442da39ad6e5c01d5c9b85dbf ("USB:
> implement non-tree resume ordering constraints for PCI host controllers").

Ah, missing "void", sorry about that.  Should be fixed now.

Rafael
