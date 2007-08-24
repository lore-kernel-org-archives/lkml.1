Return-Path: <linux-kernel-owner+w=401wt.eu-S1765787AbXHXJ3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765787AbXHXJ3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 05:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760089AbXHXJ3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 05:29:23 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57912 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbXHXJ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 05:29:23 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 24 Aug 2007 05:19:29 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: what is the value of the macro "__setup_param"?
Message-ID: <Pine.LNX.4.64.0708240516080.14019@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  perhaps i'm missing it, but it seems that the macro __setup_param is
entirely superfluous:

$ grep -rw __setup_param *
include/linux/init.h:#define __setup_param(str, unique_id, fn, early)      \
include/linux/init.h:   __setup_param(str, unique_id, NULL, 0)
include/linux/init.h:   __setup_param(str, fn, fn, 0)
include/linux/init.h:   __setup_param(str, fn, fn, 1)
include/linux/init.h:#define __setup_param(str, unique_id, fn)  /* nothing */
$

or am i must misreading something badly?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
