Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZKJMgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZKJMgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZKJMgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:36:50 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:59941 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZKJMgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:36:49 -0500
Message-ID: <4AF95E6A.3030103@davidnewall.com>
Date: Tue, 10 Nov 2009 23:06:58 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Clemens Ladisch <clemens@ladisch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
References: <4AF7D439.4030305@ladisch.de> <20091109091044.GX29442@buzzloop.caiaq.de> <4AF7DDC1.4090006@ladisch.de> <20091109095316.6283fbd6@lxorguk.ukuu.org.uk> <4AF7FC64.6030904@ladisch.de> <20091109114600.4d91b90e@lxorguk.ukuu.org.uk> <20091109145056.GB14091@buzzloop.caiaq.de> <4AF8582B.2000403@davidnewall.com> <20091109220944.GH14091@buzzloop.caiaq.de> <4AF956F8.7090707@davidnewall.com> <20091110123008.GW14091@buzzloop.caiaq.de>
In-Reply-To: <20091110123008.GW14091@buzzloop.caiaq.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> "A couple of seconds" is still too much. We don't want to give the
> impression of a terminal at all. The whole application starting
> afterwards has no cursor either.

Or even half a second. Devices regularly flash and squiggle on startup,
often as a diagnostic. Did you look at initialising your display
controller in graphics mode, or with the cursor off?
