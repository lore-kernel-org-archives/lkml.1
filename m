Return-Path: <linux-kernel-owner+w=401wt.eu-S1945959AbXBVJzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945959AbXBVJzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945958AbXBVJzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:55:20 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1079 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965047AbXBVJzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:55:17 -0500
Date: Wed, 21 Feb 2007 10:16:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-ID: <20070221101644.GH3945@ucw.cz>
References: <20070216185230.GO8882@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216185230.GO8882@enneenne.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> @@ -0,0 +1,206 @@
> +
> +			PPS - Pulse Per Second
> +			----------------------
> +
> +(C) Copyright 2007 Rodolfo Giometti <giometti@enneenne.com>

If you add copyright, add license, too.


> +PROCFS support
> +--------------
> +
> +If PROCFS support is enabled a new directory "/proc/pps" is created:
> +
> +    $ ls /proc/pps/
> +    00       01       sources
> +
> +The file "sources" holds a brief description of all PPS sources
> +defined in the system:
> +
> +    $ cat /proc/pps/sources 
> +    id    mode		echo	name			path
> +    ----  ------	----	----------------	----------------
> +    00    1133		no	serial0			/dev/ttyS0
> +    01    1133		no	serial1			/dev/ttyS1
> +
> +The other entries are directories that hold one or two files according
> +to the ability of the associated source to provide "assert" and
> +"clear" timestamps:
> +
> +    $ ls /proc/pps/00 
> +    assert		  clear
> +
> +Inside each "assert" and "clear" file you can find the timestamp and a
> +sequence number:
> +
> +    $ cat /proc/pps/00/assert 
> +    1170026870.983207967 #8

No new /proc files, please.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
