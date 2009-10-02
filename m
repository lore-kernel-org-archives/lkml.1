Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbZJBNwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbZJBNwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbZJBNwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:52:19 -0400
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:60170 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757904AbZJBNwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:52:18 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 09:52:18 EDT
From: "Trevor Hemsley" <trevor.hemsley@ntlworld.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 02 Oct 2009 14:42:20 +0100 (BST)
Reply-To: "Trevor Hemsley" <trevor.hemsley@ntlworld.com>
X-Mailer: PMMail 2.20.2382 for OS/2 Warp 4.5
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Subject: Temperature above threshold loop with 2.6.31.1
Message-Id: <20091002134430.SOPU22934.aamtaout04-winn.ispmail.ntl.com@trevor2.dsl.pipex.com>
X-Cloudmark-Analysis: v=1.0 c=1 a=QWFenfmtO-cA:10 a=9YlaCzn6_68A:10 a=z4lA2OyCn4Q8njfsJJAA:9 a=Zk-aDmChta1_xcFua6EA:7 a=l7BtrpnvemrQ6_t7NWbiPihUTVoA:4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I just downloaded and installed the latest 2.6.31.1 kernel on my
machine here and I think I found a small bug. Shortly after boot I
start to receive messages like 

CPU0: Temperature above threshold, cpu clock throttled (total events =
21672)

This is on an Intel D975XBX2 motherboard with an Intel Xeon X3220
2.4GHz quad core chip installed (the Xeon equivalent of a Q6600). The
BIOS reports the cpu temperature as being consistently 51C which may be
a bit on the high side but not dangerously so.

And, yes, I'm aware that this might be a valid temperature warning and
I aim to dismantle the machaine and check everything out over the
weekend but...

More importantly, I get approximately 100,000 of these messages per
minute and the machine is completely unusable. All of these are for
CPU0 - at least all the ones that get written to /var/log/messages. 

1,666 notifications a second seems a little on the 'too frequent' side
of things to me :-)

Please cc me on any replies as I'm not subscribed to the list. Thanks.


-- 
Trevor Hemsley, Brighton, UK
Trevor dot Hemsley at ntlworld dot com

