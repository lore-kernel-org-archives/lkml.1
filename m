Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbXJVLbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbXJVLbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXJVLbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:31:31 -0400
Received: from memebeam.org ([80.68.89.71]:4303 "EHLO jvb.vm.bytemark.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbXJVLba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:31:30 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2007 07:31:30 EDT
Message-ID: <471C88E2.3020102@neggie.net>
Date: Mon, 22 Oct 2007 07:26:26 -0400
From: John Belmonte <john@neggie.net>
User-Agent: Icedove 1.5.0.12 (X11/20070730)
MIME-Version: 1.0
To: Jonathan McDowell <noodles@earth.li>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add bluetooth support to toshiba-acpi driver
References: <20071021173529.GH1880@earth.li>
In-Reply-To: <20071021173529.GH1880@earth.li>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds bluetooth support to the toshiba-acpi driver. I have
> tried to follow the same format for the /proc/acpi/toshiba/bluetooth
> file as followed in the thinkpad-acpi driver. In the long term the
> rfkill infrastructure looks like the way forward for this functionality,
> but at present it doesn't seem to be suitable.
> 
> Traditionally the userland "toshset" program would have been used to
> enable bluetooth, but this requires either CONFIG_TOSHIBA or a patched
> toshiba-acpi to emulate the /dev/toshiba device. Also toshset doesn't
> currently run in 64bit mode.
> 
> Patch has been successfully tested on a Portégé R200 (in 32bit mode) and
> an R500 (in 64bit mode).
> 
> Signed-Off-By: Jonathan McDowell <noodles@earth.li>

The /proc/acpi/toshiba interface should not be expanded-- do not apply
this patch.  If any patch is applied, it would be to optionally
implement the generic /dev/toshiba interface so that user space tools
like toshset can operate.

--John Belmonte
