Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbXJJPEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbXJJPEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbXJJPEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:04:33 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38132 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933AbXJJPEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:04:32 -0400
Message-Id: <1192028669.25145.1215155009@webmail.messagingengine.com>
X-Sasl-Enc: o2X/t0Cyhle8hHGlUeTdM9G44l8D9XnyzbFDRuUnm28h 1192028669
From: "Jupe" <jupejupe@rushpost.com>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Ethernet driver problem
Date: Wed, 10 Oct 2007 08:04:29 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have written an ethernet driver for an ARM based board.
Linux version: 2.6.20.1

Ping is working fine.

I have written a test server/client application using socket programming
(TCP).
After the connection is setup the server sends a file to the client.

When I run server on PC and client on ARM board it works without any
problem.

BUT if I run server on ARM board and client on PC, it works for some
time and 
then the speed is drastically reduced. (I am sending 4k of data each
time.
after 50 sends it reduces its speed.  This happens always.)

I did some debugging and found that after 50 sends, tcp_sendmsg() is not
being 
called at the same frequency before slowdown.  Also when my driver
ether_tx seems to 
be working fine.

But still i am not able to get the reason for this behaviour.  Can
anyone give hints as to 
why this is happening? 


Regards
Jupe

-- 
  Jupe
  jupejupe@rushpost.com

-- 
http://www.fastmail.fm - mmm... Fastmail...

