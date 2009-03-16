Return-Path: <linux-kernel-owner+w=401wt.eu-S1762072AbZCPTlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072AbZCPTlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbZCPTlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:41:08 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:33118 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbZCPTlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:41:06 -0400
Date: Mon, 16 Mar 2009 19:40:57 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Rob Landley <rob@landley.net>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com, tytso@mit.edu,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: ext2/3: document conditions when reliable operation is possible
Message-ID: <20090316194057.GA27897@silver.sucs.org>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316123051.GJ2405@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316123051.GJ2405@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 01:30:51PM +0100, Pavel Machek wrote:
> +	Unfortunately, none of the cheap USB/SD flash cards I've seen
> +	do behave like this, and are thus unsuitable for all Linux
> +	filesystems I know.

When you say Linux filesystems do you mean "filesystems originally
designed on Linux" or do you mean "filesystems that Linux supports"?
Additionally whatever the answer, people are going to need help
answering the "which is the least bad?" question and saying what's not
good without offering alternatives is only half helpful... People need
to put SOMETHING on these cheap (and not quite so cheap) devices... The
last recommendation I heard was that until btrfs/logfs/nilfs arrive
people are best off sticking with FAT -
http://marc.info/?l=linux-kernel&m=122398315223323&w=2 . Perhaps that
should be mentioned?

> +* either write caching is disabled, or hw can do barriers and they are enabled.
> +
> +	   (Note that barriers are disabled by default, use "barrier=1"
> +	   mount option after making sure hw can support them). 
> +
> +	   hdparm -I reports disk features. If you have "Native
> +	   Command Queueing" is the feature you are looking for.

The document makes it sound like nearly everything bar battery backed
hardware RAIDed SCSI disks (with perfect firmware) is bad  - is this
the intent?

-- 
Sitsofe | http://sucs.org/~sits/
