Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZGDXob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZGDXob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 19:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZGDXoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 19:44:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48281 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbZGDXoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 19:44:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] Driver Core: Add platform device arch data V3
Date: Sun, 5 Jul 2009 01:44:39 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, khilman@deeprootsystems.com,
       gregkh@suse.de, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
References: <20090610121659.27937.13560.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090610121659.27937.13560.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907050144.40444.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 June 2009, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> Allow architecture specific data in struct platform_device V3.
> 
> With this patch struct pdev_archdata is added to struct
> platform_device, similar to struct dev_archdata in found in
> struct device. Useful for architecture code that needs to
> keep extra data associated with each platform device.
> 
> Struct pdev_archdata is different from dev.platform_data, the
> convention is that dev.platform_data points to driver-specific
> data. It may or may not be required by the driver. The format
> of this depends on driver but is the same across architectures.
> 
> The structure pdev_archdata is a place for architecture specific
> data. This data is handled by architecture specific code (for
> example runtime PM), and since it is architecture specific it
> should _never_ be touched by device driver code. Exactly like
> struct dev_archdata but for platform devices.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Applies to next-20090610.
> 
>  Changes since V2:
>  - updated commit message, thanks to Rafael for feedback
> 
>  Changes since V1:
>  - post to lkml, keep linux-pm cc:ed
>  - add struct pdev_archdata to asm-generic
>  - add struct pdev_archdata to non-generic architectures
>  - drop Kconfig bits

The patch is now in the linux-next branch of the suspend-2.6 tree.  I'll move
it into the for-linus branch, which is not rebased, if it's not reported to
cause any problems in the next few days.

Best,
Rafael
