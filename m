Return-Path: <linux-kernel-owner+w=401wt.eu-S1765234AbYBOIwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765234AbYBOIwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbYBOIwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:52:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:24686 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbYBOIwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:52:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O3LJfLJi8V7eaaZC+BbHv7OMYuA6u8AZuCCD0plXS3X3IzXxWPH53/vWkF+EhWAwQXWyFphqfdAHZvshu5TgrAZgIdIQiskUKG5KA1aH256ngTNnqFbxWZkx6ZjZjvda70dIcZpUy/rFXJdHP622AzbplogalEmjqaqj9qyWn+0=
Message-ID: <b6a2187b0802150052jcfd9c96k2a6abcd1c7fea399@mail.gmail.com>
Date: Fri, 15 Feb 2008 16:52:18 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Frans Pop" <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20080215065952.GB8916@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802111623.38478.elendil@planet.nl>
	 <200802131239.14305.elendil@planet.nl>
	 <20080213165837.GA10129@suse.de> <200802131955.53821.rjw@sisk.pl>
	 <20080215065952.GB8916@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 2:59 PM, Greg KH <gregkh@suse.de> wrote:
>  I swear someone else sent this in, but my archives don't show it at all.
>  I think the patch below should solve this, but I need someone to test it.

I tested but it doesn't fix the problem for me. May be my problem is
different ... as my X60s just doesn't power-off on suspend-to-disk.

My .config says ...
     # CONFIG_CPU_FREQ is not set
     # CONFIG_CPU_IDLE is not set


On Wed, Feb 13, 2008 at 3:54 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  due to softlockup changes, and setting CONFIG_DETECT_SOFTLOCKUP=n ...

Also, I've tried CONFIG_DETECT_SOFTLOCKUP=n, but this doesn't fix it either.


Here's the last dmesg after suspend-to-disk and hang there...

CPU 1 is now offline
SMP alternatives: switching to UP code
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  ^H-^Hdone (0 pages freed)
PM: Freed 0 kbytes in 0.10 seconds (0.00 MB/s)
ACPI: Preparing to enter system sleep state S4
Suspending console(s)

[ ... it just hangs here ... press power-switch does the job, and
system is able to resume upon powering on ]


Thanks,
Jeff.
