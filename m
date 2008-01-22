Return-Path: <linux-kernel-owner+w=401wt.eu-S1760526AbYAVIxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526AbYAVIxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 03:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYAVIw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 03:52:58 -0500
Received: from styx.suse.cz ([82.119.242.94]:33483 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755111AbYAVIw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 03:52:57 -0500
Date: Tue, 22 Jan 2008 09:19:31 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux and remote control device
Message-ID: <20080122081931.GC5591@suse.cz>
References: <38b2ab8a0801220001t284c41bdo42b534599249df2a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b2ab8a0801220001t284c41bdo42b534599249df2a@mail.gmail.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 09:01:10AM +0100, Francis Moreau wrote:
> Hello,
> 
> I'd like to add support for my Infrared remote control to Linux.
> 
> So far I only see LIRCD project that make the kernel support
> such device but I'm not sure if this project is the best choice
> since it's not part of mainline kernels. And there are certainly
> good reasons which I'm not aware of.
> 
> Another possibility is to make the remote controle device an input
> device. But I see several flaws:
> 
> - The IR receiver on my board can't be use as a transmitter any
> more

The input subsystem moves events in both directions. It would need some
additional hacking to work with IR transmitters, but it might be
possible.

> - All scancodes are embedded in the kernel.

While they reside in the kernel, they can be changed from userspace.

> Do you think it's still the way to go despite the 2 points raised above ?

It might be, but I'm not 100% convinced either.

-- 
Vojtech Pavlik
Director SuSE Labs
