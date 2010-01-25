Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268Ab0AYHhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab0AYHhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 02:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088Ab0AYHhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 02:37:09 -0500
Received: from static-122-103-239-153.ng-fam.svips.gol.ne.jp ([122.103.239.153]:62209
	"EHLO priv.dyadic.cynic.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033Ab0AYHhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 02:37:08 -0500
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jan 2010 02:37:08 EST
Date: Mon, 25 Jan 2010 16:27:49 +0900
From: Curt Sampson <cjs@starling-software.com>
To: linux-kernel@vger.kernel.org
Subject: Problems Receiving UDP Broadcasts on Some Versions of Linux
Message-ID: <20100125072749.GG21419@analytic.cynic.net>
Mail-Followup-To: Curt Sampson <cjs@starling-software.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm posting this here because it smells as if it may be something
a where a kernel network code developer might just say, "oh yeah,
obviously your problem is this."

I'm not subscribed to this list, so please cc me on any replies. (The
Mail-followup-to header may do this automatically for you.)

The short summary is that on two very similar servers on the same
network, an application that listens for broadcast UDP packets on a
given port works fine on the Ubuntu 8.04/Linux 2.6.24-26-server box but
does not receive the packets on the Ubuntu 9.04/Linux 2.6.28-17-server
box. I have confirmed that tcpdump sees identical packets being received
on both hosts.

Did something change between these two kernel revisions that I need to
listen differently?

Full details, including sample code, are available at:

  http://stackoverflow.com/questions/2130563/udp-broadcast-reception-problems-with-ubuntu-9-04-but-not-8-04

Thanks for any help you can give me. Even if you're not sure, but have
clues I should consider following up, feel free to e-mail me. I'm
also happy to take pointers to kernel code I should read, if there's
enlightenment there.

cjs
-- 
Curt Sampson         <cjs@cynic.net>         +81 90 7737 2974
             http://www.starling-software.com
The power of accurate observation is commonly called cynicism
by those who have not got it.    --George Bernard Shaw
