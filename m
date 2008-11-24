Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYKXQwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYKXQwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYKXQwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:52:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57962 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751920AbYKXQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:52:36 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] hso: refcounting and termios bits
To: linux-kernel@vger.kernel.org, d.barrow@option.com
Date: Mon, 24 Nov 2008 16:52:48 +0000
Message-ID: <20081124165119.30899.7515.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring the HSO driver into line with the latest features and tidy the termios
handling. These are patches for comment and ad{oa}ption by the maintainer of
the driver rather than for application.

Alan

---

Alan Cox (2):
      tty: Fix the HSO termios handling a bit
      hso: net driver using tty without locking


 drivers/net/usb/hso.c |  103 +++++++++++++++++++++++++++++++++----------------
 1 files changed, 70 insertions(+), 33 deletions(-)

-- 
	"Yeah, back in the good old days the rich were much freer from
		the burden of the poor."
				-- Michael Foord

