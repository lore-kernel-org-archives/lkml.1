Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbZAIXeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbZAIXeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757663AbZAIXd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:33:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59480 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756955AbZAIXd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:33:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/8] PCI PCIe portdrv: Remove root ports MSI quirk
Date: Sat, 10 Jan 2009 00:33:09 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl> <200901042348.22012.rjw@sisk.pl> <200901091518.25220.jbarnes@virtuousgeek.org>
In-Reply-To: <200901091518.25220.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901100033.09569.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2009, Jesse Barnes wrote:
> On Sunday, January 4, 2009 2:48 pm Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > The PCI Express port driver contains a quirk that prevents root
> > ports from using MSI, but there is no explanation for it and the
> > PCI Express specification clearly allows root ports to use MSI.
> 
> Ah ignore my last message, it really does look like some chipsets are just 
> buggy here, and the quirk only affects a few, so it should be pretty harmless 
> for the most part (iow I don't think this patch is a good idea on those 
> chipsets).

But this means we're not going to use MSI for PCIe PME at all, for example.

I'd be very much interested in learning which chipsets are affected and whether
we can make the quirk more specific.

Thanks,
Rafael
