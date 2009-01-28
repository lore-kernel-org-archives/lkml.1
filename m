Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436AbZA1Tx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbZA1Tx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZA1Txt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:53:49 -0500
Received: from aun.it.uu.se ([130.238.12.36]:44715 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbZA1Txs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:53:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18816.47047.304831.827133@harpo.it.uu.se>
Date: Wed, 28 Jan 2009 20:53:43 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: if (unlikely(...)) == unnecessary?
In-Reply-To: <alpine.DEB.1.10.0901272346480.20262@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901272346480.20262@alien.or.mcafeemobile.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi writes:
 > I noticed that GCC >= 3.3 (not tried the ones before) automatically 
 > branches out the "if" code (and follow-through the "else" code, if there). 
 > Is that a coincidence or a rule we can rely on going forward?

Coincidence.

Why on earth would you want to rely on an purely private implementation
detail like that?
