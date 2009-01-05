Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbZAEAlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbZAEAlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 19:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZAEAl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 19:41:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54679 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751880AbZAEAlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:41:20 -0500
Date: Mon, 5 Jan 2009 00:41:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Chris Adams <cmadams@hiwaay.net>, linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
Message-ID: <20090105004123.374709ff@lxorguk.ukuu.org.uk>
In-Reply-To: <49614DD8.7070707@davidnewall.com>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	<20090102210430.49649261@diego-desktop>
	<495E7849.4030706@shaw.ca>
	<495F0672.6020708@davidnewall.com>
	<8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>
	<496076A9.7030907@davidnewall.com>
	<f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
	<4960897D.5030603@davidnewall.com>
	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	<4961432A.80509@davidnewall.com>
	<20090104232534.GB1297917@hiwaay.net>
	<49614DD8.7070707@davidnewall.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> zoneinfo.  Epoch remains the start of  1978; seconds between any two
> dates included leap-seconds and no special kernel support is required.

Your time() values then disagree with the rest of the universe. See POSIX
1003.1 Annex B 2.2.2. if you want the whole story,

For any given time based on the 1970 Epoch there is a single correct
answer for the translation between each value and a UTC time.

