Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbXJLMIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbXJLMIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759204AbXJLMI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:08:26 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39518 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbXJLMI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:08:26 -0400
X-Originating-Ip: 99.236.101.138
Date: Fri, 12 Oct 2007 08:04:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: what is the rationale for "TAINT_USER"?
Message-ID: <Pine.LNX.4.64.0710120801380.20049@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  i can see what the theoretical purpose for it is here:

http://kerneltrap.org/node/6656

but it's not clear how it can possibly be set from userland given
that:

$ grep -r TAINT_USER *
include/linux/kernel.h:#define TAINT_USER                       (1<<6)
kernel/panic.c:                 tainted & TAINT_USER ? 'U' : ' ',
$

  am i missing something screamingly obvious?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
