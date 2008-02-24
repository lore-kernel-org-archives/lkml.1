Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYBXMaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYBXMaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 07:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYBXMaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 07:30:05 -0500
Received: from nn7.de ([85.214.94.156]:51712 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbYBXMaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 07:30:04 -0500
Subject: Re: 2.6.25-current-git hangs on boot
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Oliver Pinter <oliver.pntr@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <200802241218.04617.rjw@sisk.pl>
References: <1203789325.4063.9.camel@localhost>
	 <6101e8c40802231100t3af57018r139de0b52cd556b5@mail.gmail.com>
	 <1203833710.4006.3.camel@localhost>  <200802241218.04617.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 24 Feb 2008 13:27:56 +0100
Message-Id: <1203856077.4356.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-24 at 12:18 +0100, Rafael J. Wysocki wrote:
> On Sunday, 24 of February 2008, Soeren Sonnenburg wrote:
> > On Sat, 2008-02-23 at 20:00 +0100, Oliver Pinter wrote:
> > > the pci=nommconf kernel parameter helped it?
> > 
> > yes indeed, this switch reliably helps to over come the hang at *this
> > stage* (I tried booting with booth the switch and w/o).
> > 
> > however with 50% chance I still see a hang directly after
> > 
> > cpuidle: using governor ladder
> 
> Do you have CONFIG_CPU_IDLE set?  If you have, please try to unset it and
> retest.

Yes I had. When disabling that option booting 10 times in a row worked
without problems.

Soeren
