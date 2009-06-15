Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbZFOOdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbZFOOdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZFOOdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:33:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57560 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751689AbZFOOdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:33:35 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] Debug bits for the tty ldisc problem
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Mon, 15 Jun 2009 16:32:01 +0100
Message-ID: <20090615153015.4036.76588.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See if this turns anything up or fixes it. I'm not 100% sure the close one is
safe for locking but as the lock detector has been busted since 2.6.30 its a
bit hard to be sure.
---

Alan Cox (2):
      ldisc: debug aids
      ldisc: Make sure the ldisc isn't active when we close it


 drivers/char/tty_ldisc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

-- 
	"In flight refueling scares me. It's like two elephants 
			mating at mach one"
				-- Arjan van de Ven

