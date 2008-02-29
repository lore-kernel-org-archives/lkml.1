Return-Path: <linux-kernel-owner+w=401wt.eu-S932685AbYB2NiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685AbYB2NiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYB2NiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:38:03 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:58894 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbYB2NiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:38:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=xYA3CgFjeWQxROGpygarjMwLuWle5n4CVO8lfZvXApDbv/zRTBdJoc24Lfu6LJayT8GA5zJXA4aD4s4m52PhsIcWDb+kNFIC3UvuhyonpfAzM7wUS51azRBkF5EeLxb1X7Efi4h+kKCGGLo0lMy6DBqDbN6Y/G0bmd5Hj4q1X38=
Message-ID: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com>
Date: Fri, 29 Feb 2008 08:38:00 -0500
From: "Stephen Cuppett" <cuppett@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Performance versus FreeBSD 7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not lobbing the first artillery shell by any means, but I saw this
bullet on the FreeBSD release announcement:

# Dramatic improvements in performance and SMP scalability shown by
various database and other benchmarks, in some cases showing peak
performance improvements as high as 350% over FreeBSD 6.X under normal
loads and 1500% at high loads. When compared with the best performing
Linux kernel (2.6.22 or 2.6.24) performance is 15% better. Results are
from benchmarks used to analyze and improve system performance,
results with your specific work load may vary. Some of the changes
that contribute to this improvement are:

    * The 1:1 libthr threading model is now the default.
    * Finer-grained IPC, networking, and scheduler locking.
    * A major focus on optimizing the SMP architecture that was put in
place during the 5.x and 6.x branches.

Some benchmarks show linear scaling up to 8 CPUs. Many workloads see a
significant performance improvement with multicore systems.

The whole thing is available at:

http://www.freebsd.org/releases/7.0R/announce.html

However, their site is pretty scant on details about those benchmarks.
 Was just curious if anybody on this list had any input or links on
the metrics, the hardware, the workloads, how was Linux or FreeBSD
tuned, knew more information, could point me to the stats....
