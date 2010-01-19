Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473Ab0ASWAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0ASWAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353Ab0ASWAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:00:18 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:1697 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474Ab0ASWAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:00:16 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANC4VUtbssBB/2dsb2JhbADZQwqEKQQ
Date: Tue, 19 Jan 2010 23:00:14 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian@openwrt.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Joe Perches <joe@perches.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-omap@vger.kernel.org
Subject: Re: [RFC] [PATCH] watchdog_info separation and constify
Message-ID: <20100119220014.GG3804@infomag.iguana.be>
References: <20100119211759.GE3804@infomag.iguana.be> <20100119212755.72e81d24@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119212755.72e81d24@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> > please comment on following patch.
> 
> Why move them out - why not just make them const ?

There's 2 options:
1) we only make them const now. And we move them out later when we do the conversion to the generic watchdog api (which means that we will rip out the code for the open, release, write and ioctl handling of /dev/watchdog) or
2) we make them const and move them out of ioctl and then the ripping out of the code is much easier.

I opted for the second option.

Kind regards,
Wim.

