Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXDIK1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXDIK1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 06:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXDIK1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 06:27:36 -0400
Received: from smtp-out03.alice.it ([85.37.17.99]:4088 "EHLO
	smtp-out03.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbXDIK1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 06:27:36 -0400
Date: Mon, 9 Apr 2007 12:27:11 +0200
From: Giuliano Pochini <pochini@shiny.it>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: ppc+k3b=crash
Message-Id: <20070409122711.5c8af66b.pochini@shiny.it>
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; powerpc-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Apr 2007 10:27:33.0263 (UTC) FILETIME=[AF4379F0:01C77A91]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When insert a CD-R that contains data and k3b is running the machine hard
locks. k3b writes on the console:

/dev/hdd READ TOC/PMA/ATIP invalid length returned
Disk info:
[...]
Used size: [...]
<crash>

Sys-rq doesn't work and there is nothing in the logs. I tested kernels back
to 2.6.14 and they all crash (I had problem booting .13 and .12... I'll try
again later). I also tried without iso9660 and udf support with same result.
Any clue ?


(
Linux Jay 2.6.20 #1 SMP Mon Feb 5 22:42:18 CET 2007 ppc 7455, altivec supported PowerMac3,6 GNU/Linux
no preempt
also booted with maxcpus=1
)

--
Giuliano.
