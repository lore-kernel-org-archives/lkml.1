Return-Path: <linux-kernel-owner+w=401wt.eu-S932748AbZGRLsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbZGRLsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbZGRLsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:48:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60546 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546AbZGRLsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:48:32 -0400
Date: Sat, 18 Jul 2009 13:48:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@redhat.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vga: drops a documentation regarding the VGA
	arbiter
Message-ID: <20090718114817.GD1433@ucw.cz>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com> <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com> <1247576250-16274-3-git-send-email-tiago.vignatti@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247576250-16274-3-git-send-email-tiago.vignatti@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +I. Details and Theory of Operation
> +==================================
> +
> +I.1 vgaarb
> +----------
> +
> +The vgaarb is a module of the Linux Kernel. When it is initially loaded, it
> +scans all PCI devices and add the VGA ones inside the arbitration. The arbiter

and adds?


> +If the device is hot-{un,}plugged, there is a hook inside the module to notify
> +them being added/removed in the system and automatically added/removed in
> +the arbiter.

I don't see who's 'them' here.

> +I.2 libpciaccess
> +----------------
> +
> +To use the vga arbiter char device it was implemented a serie of functions

series?

> +inside the pciaccess library. Two fields were added to struct pci_device for
> +this be possible:
> +
> +    /* the type of resource decoded by the device */
> +    int vgaarb_rsrc;
> +    /* the file descriptor (/dev/vga_arbiter) */
> +    int vgaarb_fd;
> +
> +
> +and the functions:
> +

What functions?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
