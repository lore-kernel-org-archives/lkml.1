Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbXAaJM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbXAaJM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXAaJM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:12:58 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:53569 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbXAaJM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:12:57 -0500
Subject: Re: [linux-usb-devel] 2.6.20-rc6 SCSI error: I/O error - trouble
	with mass storage devices ?!
From: Soeren Sonnenburg <kernel@nn7.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0701301300050.7522-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0701301300050.7522-100000@iolanthe.rowland.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 31 Jan 2007 10:12:47 +0100
Message-Id: <1170234767.4366.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 13:08 -0500, Alan Stern wrote:
> On Sat, 27 Jan 2007, Soeren Sonnenburg wrote:

[P990 mass storage trouble]
> > Now I am clueless what could have gone wrong (as I *think* this was all
> > working at some point at least before firmware updates) and what the
> > difference between these mass storage devices is.
> 
> The log revealed that the phone's firmware returns garbage values in the 
> Residue field for some WRITEs.  This patch should take care of it.

I can confirm that this fixes the problem.

Thank you *very* much - you've made my day.

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
