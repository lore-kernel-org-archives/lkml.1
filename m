Return-Path: <linux-kernel-owner+w=401wt.eu-S934378AbZKXXQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378AbZKXXQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934333AbZKXXQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:16:49 -0500
Received: from foo.birdnet.se ([213.88.146.6]:35889 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934326AbZKXXQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:16:49 -0500
Message-ID: <20091124231653.30084.qmail@stuge.se>
Date: Wed, 25 Nov 2009 00:16:52 +0100
From: Peter Stuge <peter@stuge.se>
To: x86@kernel.org, Komuro <komurojun-mbn@nifty.com>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: ioports 0x100-0x3af and iomem 0xd000-0xdffff,
	0xa0000000-0xa0ffffff -- safe to use on x86 for pcmcia?
Mail-Followup-To: x86@kernel.org, Komuro <komurojun-mbn@nifty.com>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20091124213723.GA22689@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124213723.GA22689@comet.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dominik Brodowski wrote:
> 	include port 0x100-0x3af
> 	include memory 0xc0000-0xfffff
> 	include memory 0xa0000000-0xa0ffffff
..
> Do you think it would be safe to enable these areas by (kernel)
> default on x86?

c0000-fffff is option ROM and BIOS land. Maybe every BIOS out there
is being a good boy/girl and actually adds entries to e820 or similar
but I would kindof like to stay away from the region anyway.

0xa0000000 is 2.5GB, so it's doomed on systems with >=2.5GB RAM. :(


//Peter
