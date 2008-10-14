Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYJNK4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYJNK4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 06:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYJNK4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 06:56:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37342 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754538AbYJNK4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 06:56:36 -0400
Date: Tue, 14 Oct 2008 11:56:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [REVERT Request] VT Breakage
Message-ID: <20081014115632.600a7506@lxorguk.ukuu.org.uk>
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

In April someone merged

commit c9e587abfdec2c2aaa55fab83bcb4972e2f84f9b
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Apr 29 00:59:46 2008 -0700

    vt: fix background color on line feed


Unfortunately it's wrong and its been causing breakages because various
apps like ncurses expect our previous (and correct) behaviour.

Can you therefore revert it (seems saner than sending you a patch -R)

