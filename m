Return-Path: <linux-kernel-owner+w=401wt.eu-S965667AbXCSGIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965667AbXCSGIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 02:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965671AbXCSGIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 02:08:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50061 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965667AbXCSGIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 02:08:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45FE28B6.7040200@s5r6.in-berlin.de>
Date: Mon, 19 Mar 2007 07:07:50 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070303 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee1394: remove usage of skb_queue as packet queue
References: <tkrat.be8814c580bba408@s5r6.in-berlin.de> <59ad55d30703181934o1442ab44rcc11fbeac62ca7c0@mail.gmail.com>
In-Reply-To: <59ad55d30703181934o1442ab44rcc11fbeac62ca7c0@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> But the question is, is it worth it?  One of the primary reasons for
> me to write an alternative stack was to be able to leave linux1394
> in maintenence mode.

I have been asking this myself on nearly every one of my patches since
you announced the new stack. :-)

The skb change here, which I wanted to do for some time, was prompted by
/a/ trouble with skb lock annotations when lockdep went mainline and /b/
a very recent bug report http://bugzilla.kernel.org/show_bug.cgi?id=8216
which first read like -ENOBUG but then motivated me to clean up
hpsb_packet a bit and also pointed me to a raw1394 bug.  (Besides, most
of the cleanup patches which I came up with were meant to pave the way
for actual bug fixes.  I'm just extremely slow with following up with
the latter.)
-- 
Stefan Richter
-=====-=-=== --== =--==
http://arcgraph.de/sr/
