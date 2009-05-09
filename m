Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZEIODz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZEIODz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZEIODr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:03:47 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:46704 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbZEIODq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:03:46 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905091403.n49E3fb5025843@mercury.physics.adelaide.edu.au>
Subject: Realtek 8168D: no active link (2.6.29.2)
To: linux-kernel@vger.kernel.org
Date: Sat, 9 May 2009 23:33:40 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am currently testing a Gigabyte EX58-UD4P mainboard which is equipped with
an onboard Realtek RTL-8168D network controller.  The kernel version is
2.6.29.2.  The r8169 module is loaded correctly, identifies the chip as an
8168D and seemingly is happy.  However, after loading the module the link
remains dead.  The green and orange status LEDs remain off at all times.

It doesn't seem to matter whether the remote end of the network line is
plugged into a switch when the computer is booted.  Repeatedly removing and
inserting the r8169 module also doesn't help.  In short, it seems impossible
to get a functioning network link with the 8168D.

Support for the 8168D appears relatively recent given related patch activity
around October 2008, so I'm guessing it's still a work in progress.  I would
be happy to test patches and run other tests if it will help make the
8168D-based chipsets work better.  Alternatively, if there's a known
workaround to get the 8168D working now I would be interested to try it.

Regards
  jonathan
