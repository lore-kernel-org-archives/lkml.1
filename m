Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYBXLTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYBXLTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 06:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYBXLTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 06:19:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52253 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbYBXLTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 06:19:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.25-current-git hangs on boot
Date: Sun, 24 Feb 2008 12:18:04 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Oliver Pinter <oliver.pntr@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
References: <1203789325.4063.9.camel@localhost> <6101e8c40802231100t3af57018r139de0b52cd556b5@mail.gmail.com> <1203833710.4006.3.camel@localhost>
In-Reply-To: <1203833710.4006.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802241218.04617.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of February 2008, Soeren Sonnenburg wrote:
> On Sat, 2008-02-23 at 20:00 +0100, Oliver Pinter wrote:
> > the pci=nommconf kernel parameter helped it?
> 
> yes indeed, this switch reliably helps to over come the hang at *this
> stage* (I tried booting with booth the switch and w/o).
> 
> however with 50% chance I still see a hang directly after
> 
> cpuidle: using governor ladder

Do you have CONFIG_CPU_IDLE set?  If you have, please try to unset it and
retest.

Thanks,
Rafael
