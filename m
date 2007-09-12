Return-Path: <linux-kernel-owner+w=401wt.eu-S933724AbXILJbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724AbXILJbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 05:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763454AbXILJbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 05:31:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:48658 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763465AbXILJbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 05:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=LFA5mFJ7CWDSAj4fhSu3sLbStEXcuIWOzZOdA9QZW5p3Qc/9xszgciDF/5jmGrZVfPALIwobdt8QSCsxlgdBFatJwqghTMXPlBlKPV/tsdmbk4F9lr76QMDWxUXvQK3ZiPpX1M9vJwTNkvKyLOXhSlMH4sq0jtvOpUaBWrdc8CM=
Message-ID: <46E7B1EA.2040009@gmail.com>
Date: Wed, 12 Sep 2007 11:31:22 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matt Mackall <mpm@selenic.com>, jason.wessel@windriver.com,
       amitkale@linsyssoft.com, kgdb-bugreport@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc4-mm1: kgdboe link errors
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

randconfig [1] causes this link errors:
ERROR: "netpoll_cleanup" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_setup" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_parse_options" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_poll" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_send_udp" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_set_trap" [drivers/net/kgdboe.ko] undefined!
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make: *** [all] Error 2

[1] http://www.fi.muni.cz/~xslaby/sklad/1.config

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
