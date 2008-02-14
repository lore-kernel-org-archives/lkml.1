Return-Path: <linux-kernel-owner+w=401wt.eu-S1764849AbYBNWas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764849AbYBNWas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbYBNWah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:30:37 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:59952 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbYBNWag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:30:36 -0500
Date: Thu, 14 Feb 2008 23:30:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Nicol <davidnicol@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: warning with 2.6.24.2 linking
Message-ID: <20080214223045.GJ21894@uranus.ravnborg.org>
References: <934f64a20802141415o6d2aee9au187a3d3afb15cd53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <934f64a20802141415o6d2aee9au187a3d3afb15cd53@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 04:15:41PM -0600, David Nicol wrote:
> Do we care?
> 
> 
>   AS      .tmp_kallsyms2.o
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0xe51ac): Section mismatch: reference to
> .init.text:pcibios_fixup_bus (between 'pci_scan_child_bus' and
> 'pci_scan_bus_parented')
>   LD      vmlinux
>   SYSMAP  System.map
>   SYSMAP  .tmp_System.map

I plan to fix this - so yes.

	Sam
