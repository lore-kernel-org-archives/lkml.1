Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbYBSWto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbYBSWto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYBSWtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:49:36 -0500
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:15071 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938AbYBSWtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:49:35 -0500
From: Frans Pop <elendil@planet.nl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Unable to continue testing of 2.6.25
Date: Tue, 19 Feb 2008 23:49:32 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200802171025.30590.elendil@planet.nl> <200802192255.02152.elendil@planet.nl> <20080219221914.GL31955@cs181133002.pp.htv.fi>
In-Reply-To: <20080219221914.GL31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192349.33347.elendil@planet.nl>
X-OriginalArrivalTime: 19 Feb 2008 22:49:34.0087 (UTC) FILETIME=[B2471970:01C87349]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, Adrian Bunk wrote:
> The "or any other emulator" is exactly where my question is directed at.
>
> Xen, KVM or even qemu come into my mind, but considering how loudly you
> complained about a temporary breakage for VirtualBox there must be a
> reason why your work on the Debian Installer can only be done
> effectively and efficiently with an emulator module that has AFAIK not
> been submitted for inclusion in the kernel.

- Xen is currently not supported by the kernel Debian Installer uses (though 
work is being done to change that.
- KVM AFAIK requires hardware support that I don't have.
- QEMU is completely useless because of its slow speed without the (also out 
of tree) kqemu module, which does not work when the host system is x86_64 
[1]. Also, I very much prefer the VirtualBox user interface over what qemu 
has to offer.
- I've actually used VMWare for a long time (licenced), but stopped after 
the 5 series stopped working with current kernels and around that time 
VirtualBox became available as an alternative.

Hope that explains.

Cheers,
FJP

[1] http://bugs.debian.org/444160
