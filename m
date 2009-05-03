Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbZECK2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbZECK2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 06:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbZECK2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 06:28:16 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42265 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZECK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 06:28:15 -0400
Date: Sun, 3 May 2009 12:30:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Anders Kaseorg <andersk@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lots of unexpected non-allocatable section warnings
Message-ID: <20090503103010.GA27978@uranus.ravnborg.org>
References: <20090503110517.6d09bca2@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503110517.6d09bca2@hyperion.delvare>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 11:05:17AM +0200, Jean Delvare wrote:
> Hi Anders, Sam,
> 
> After your fix "kbuild, modpost: Check the section flags, to catch
> missing ax/aw", I get a lot of warnings like the following during
> modpost on x86-64:
> 
> WARNING: arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.o (.comment.SUSE.OPTs): unexpected non-allocatable section.
> Did you forget to use "ax"/"aw" in a .S file?
> Note that for example <linux/init.h> contains
> section definitions for use in .S files.
> 
> Apparently there's one such warning for every module on my system, that
> is, 907. That's a lot, and pretty annoying. How do I solve this? I don't
> know much about assembly.

Cannot reproduce here..

Can you send me your config so I can try to see if this is toolchain
version related.

Also what version of gcc/binutils are you using?
Is this x86 and 32/64 bit?

	Sam
