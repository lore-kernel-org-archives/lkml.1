Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYJXH3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYJXH3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYJXH3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:29:47 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:62910 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYJXH3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:29:46 -0400
Date: Fri, 24 Oct 2008 09:28:27 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: walt <w41ter@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: commit a802dd0e breaks console keyboard input
Message-ID: <20081024072826.GA4620@osiris.boeblingen.de.ibm.com>
References: <49011234.7090902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49011234.7090902@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 05:09:24PM -0700, walt wrote:
> Hi team,
>
> commit a802dd0eb5fc97a50cf1abb1f788a8f6cc5db635
> Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date:   Mon Oct 13 23:50:08 2008 +0200
>
>     Call init_workqueues before pre smp initcalls.
>
> This commit causes the console login prompt to ignore my keystrokes
> so I'm unable to log in (though ssh works fine).  Oddly, if I hit
> ctrl-alt-delete the machine does reboot, but no other keystrokes
> appear on the screen or have any effect that I can detect.
>
> No surprise that this problem appears only on my dual-core amd64
> machine, while the k7 single processor machine works normally.
>
> I've not seen anyone else complaining on the linux list, so maybe
> this is a BIOS bug on the affected machine?  It's an ECS mobo with
> a GeForce6100PM-M2 chipset, and I use a ps/2 keyboard.

Uh? How did you get to this commit? I assume a git bisect?
Strange.. I'm going to have a look at it.
