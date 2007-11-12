Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbXKLSXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbXKLSXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXKLSW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:22:57 -0500
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:4278 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbXKLSWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:22:55 -0500
X-Greylist: delayed 1505 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2007 13:22:55 EST
Date: Mon, 12 Nov 2007 18:57:39 +0100 (CET)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: linux-kernel@vger.kernel.org
Subject: top lies ?
Message-ID: <Pine.BSO.4.63.0711121843170.3123@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-701891639-1194890259=:3123"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-701891639-1194890259=:3123
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT


Some data showed by top command looks like completly trashed.
Fragment from top output:

Mem:   2075784k total,  2053352k used,    22432k free,    19260k buffers
Swap:  2096472k total,      136k used,  2096336k free,  1335080k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  SWAP nFLT WCHAN     COMMAND
14515 mysql     20   0 1837m 563m 4132 S   39 27.8  27:14.20 1.2g   18 -         mysqld

How it is possible that swap ussage is 136k and swapped out portion of (in 
this case) mysqld process is 1.2g ?
Mayby some other data from /proc/<pid> shows some *real* data ?

Above is on procps 3.2.7 and kernel 2.6.22.12.

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-701891639-1194890259=:3123--
