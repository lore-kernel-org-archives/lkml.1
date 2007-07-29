Return-Path: <linux-kernel-owner+w=401wt.eu-S935440AbXG2P2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935440AbXG2P2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765414AbXG2P1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:27:11 -0400
Received: from echo.digadd.de ([195.47.195.234]:53295 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763147AbXG2P1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:27:09 -0400
Message-ID: <46ACB1C2.6030701@digadd.de>
Date: Sun, 29 Jul 2007 18:26:58 +0300
From: "Christian P. Schmidt" <charlie@digadd.de>
User-Agent: Thunderbird 2.0.0.5 (X11/20070726)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org
Subject: ttyS1: LSR safety check engaged! - misidentification?
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.0 (---)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Ever since Kernel 2.6.21(rc) or so I'm plagued with this message,
disabling my serial ports that have been working perfectly from 2.6.14
till that day (and are still doing so, given that I continuously remove
the code from the source).
Actually I cannot blame the code, but it seems that on both of my
laptops the LSR is actually not readable. So, is there any plan to
remove that piece of code again, or at least change it so it can be
disabled conditionally?

Regards,
Christian
