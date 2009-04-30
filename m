Return-Path: <linux-kernel-owner+w=401wt.eu-S1762866AbZD3Nsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866AbZD3Nsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762751AbZD3NsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:48:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37981 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762645AbZD3NsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:48:05 -0400
Date: Thu, 30 Apr 2009 14:47:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Alex Buell <alex.buell@munted.org.uk>, Jeff Garzik <jeff@garzik.org>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
 question)
Message-ID: <20090430144702.46415b90@lxorguk.ukuu.org.uk>
In-Reply-To: <49F95719.10701@kernel.org>
References: <E1LzLgA-0004j6-9W@closure.thunk.org>
	<49F90CA2.4080602@garzik.org>
	<20090430083309.437f9248@lithium.local.net>
	<49F95719.10701@kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, at the point of driver load, there just isn't much we can do about
> the missing ABAR.  It's sad.  Dunno why some laptop manufacturers
> still program the thing into piix mode.  :-(

Forcing out of PIIX mode would need to go into the PCI quirks and be a
boot option not a module one - at that point its doable as a header quirk.
