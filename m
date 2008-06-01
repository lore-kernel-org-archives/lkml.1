Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYFAVQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYFAVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYFAVQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:16:20 -0400
Received: from smtp5.freeserve.com ([193.252.22.128]:26805 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYFAVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:16:19 -0400
X-Greylist: delayed 1168 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2008 17:16:19 EDT
X-ME-UUID: 20080601205641812.C664F1C00091@mwinf3421.me.freeserve.com
Date: Sun, 1 Jun 2008 21:56:21 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: linux-kernel@vger.kernel.org
Subject: pppd and 2.6.25 serial driver
Message-ID: <20080601215621.256db193@boulder.homenet>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because I have had to resort to using dial-up this weekend, I noticed
that the serial driver for the 8250/16550 UART in the 2.6.25 kernel does
not work correctly with ppp-2.4.4. After establishing a dial-up modem
connection it becomes unresponsive and pppd will exit waiting to
establish a ppp connection after sending LCP configuration requests.  I
have tested this with two different dial-up modems and at two different
dial-up providers, with the 2.6.25.3 and 2.6.25.4 kernels.

pppd works fine with the 2.6.25 kernel if the serial driver is not used
(for example if establishing a ppp connection over (in kernel) ATM or
via an (out of kernel tree) softmodem driver I have.

The serial driver in 2.6.24.7 works correctly, and the good news is
that 2.6.26-rc2 also works fine.

Chris

