Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZKJMaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZKJMaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZKJMaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:30:11 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:43117 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbZKJMaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:30:09 -0500
Date: Tue, 10 Nov 2009 13:30:08 +0100
From: Daniel Mack <daniel@caiaq.de>
To: David Newall <davidn@davidnewall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Clemens Ladisch <clemens@ladisch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
Message-ID: <20091110123008.GW14091@buzzloop.caiaq.de>
References: <4AF7D439.4030305@ladisch.de>
 <20091109091044.GX29442@buzzloop.caiaq.de>
 <4AF7DDC1.4090006@ladisch.de>
 <20091109095316.6283fbd6@lxorguk.ukuu.org.uk>
 <4AF7FC64.6030904@ladisch.de>
 <20091109114600.4d91b90e@lxorguk.ukuu.org.uk>
 <20091109145056.GB14091@buzzloop.caiaq.de>
 <4AF8582B.2000403@davidnewall.com>
 <20091109220944.GH14091@buzzloop.caiaq.de>
 <4AF956F8.7090707@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF956F8.7090707@davidnewall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 10:35:12PM +1030, David Newall wrote:
> I'm having trouble seeing a flashing cursor during device startup as a
> problem. I expect it will prove a useful diagnostic, one day. I think
> you can turn it off (from user space) within a couple of seconds of
> power on; you did say embedded, didn't you? Perhaps you even can
> configure your hardware to not display the cursor on startup, which is
> the second likeliest (after user-space) place to satisfy your needs.

I'm talking about an embedded device with no keyboard connected but
only a touch screen. In this case, the cursor is clearly misleading, as
there is no input device to use it. And for such a case (and I'm sure
I'm not the only one having it), a way to switch the cursor off is much
appreciated. I don't believe that's so hard to understand, really.

"A couple of seconds" is still too much. We don't want to give the
impression of a terminal at all. The whole application starting
afterwards has no cursor either.

Daniel

