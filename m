Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbZF0L0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbZF0L0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZF0L0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:26:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41947 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZF0L0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:26:41 -0400
Date: Wed, 24 Jun 2009 17:02:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: [2.6.31-rc1] oops in acpi_get_pci_dev
Message-ID: <20090624150217.GD1512@ucw.cz>
References: <5a4c581d0906250325q1dd9ca67na9a8c7ecbffe4897@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a4c581d0906250325q1dd9ca67na9a8c7ecbffe4897@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I had similar oops here, too, on thinkpad x60. It is interesting: most
breakage seems to happen just before -rc1...

Will configuring out acpi_video help?

									Pavel

> kernel: [<ffffffff8121ef98>] find_video+0x62/0xa2
> kernel: [<ffffffff81233240>] acpi_ns_walk_namespace+0xc4/0x14d
> kernel: [<ffffffff8121ef36>] ? find_video+0x0/0xa2
> kernel: [<ffffffff8121ef36>] ? find_video+0x0/0xa2
> kernel: [<ffffffff81230b0a>] acpi_walk_namespace+0x82/0xd0
> kernel: [<ffffffff8121ecdd>] acpi_video_get_capabilities+0x61/0xe2
> kernel: [<ffffffffa000a060>] ? dell_send_request+0x60/0x82 [dell_laptop]
> kernel: [<ffffffff8121ede9>] acpi_video_backlight_support+0x27/0x64

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
