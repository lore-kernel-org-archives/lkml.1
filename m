Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYJVThw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYJVThw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYJVThn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:37:43 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:35007 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYJVThm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=aGytoUwL0y3kXoEVytAOrCz2O5GprSYIatjAHoITrPcrnewTgigPUTe/t9/wUHntN9
         uGlJg6VwB0HK+E6dClsQb+S1Bkahbay2sbRJ5yXp112W9ACeGut//VQK8+h3Hu2hy7Ht
         kyG8oQPCrtIio21mmkzSKCWgreVOPcbzXsJPc=
Message-ID: <53cc795f0810221237u1b5ece4dq477be67903dd5879@mail.gmail.com>
Date: Wed, 22 Oct 2008 23:37:40 +0400
From: sbs <gexlie@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: high %CPU values after upgrading to the last stable kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after upgrading from 2.6.16 to 2.6.27 kernel top shows a strange
picture of extremely highly %CPU values.

# top -V
        top: procps version 3.2.6


# top
top - 04:24:06 up 7 days,  1:12,  1 user,  load average: 2.28, 2.03, 2.00
Tasks: 183 total,   2 running, 181 sleeping,   0 stopped,   0 zombie
Cpu(s): 36.2% us,  2.4% sy,  0.0% ni, 56.1% id,  4.7% wa,  0.1% hi,  0.5% si
Mem:  12473092k total, 11169060k used,  1304032k free,       16k buffers
Swap:  2048248k total,      636k used,  2047612k free,  1257988k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
19824 b      20   0 92212  17m 5420 S 4308  0.1   1:39.49 httpd
14396 b      20   0 92716  28m  16m S 3721  0.2  38:47.38 httpd
14024 b      20   0 92376  28m  16m S 2437  0.2  51:49.68 httpd
 7415 b      20   0 96876  40m  24m D 2146  0.3  93:59.72 httpd
 8182 b      20   0 94500  36m  21m S 1997  0.3 111:41.60 httpd
13461 b      20   0 94240  31m  17m S 1439  0.3  48:43.71 httpd
 8466 b      20   0 92036  32m  21m S 1136  0.3 107:37.90 httpd
17620 b      20   0 92660  23m  11m S 1003  0.2  10:55.03 httpd
14025 b      20   0 92000  28m  16m S  720  0.2  51:49.49 httpd
 3808 nobody    20   0 3013m 2.9g  592 S  714 24.7 343030:50 memcached
   10 root     15  -5     0    0    0 S  714  0.0  11881:28 ksoftirqd/3
18487 b      20   0 91416  20m 9572 S  580  0.2   8:29.20 httpd
13252 b      20   0 93408  30m  17m S  580  0.3  45:19.69 httpd
17525 b      20   0 93208  23m  10m S  566  0.2  18:34.40 httpd
14760 b      20   0 93452  28m  15m S  534  0.2  57:34.65 httpd
 3804 nobody    20   0 2995m 2.9g  592 S  441 24.6 378908:26 memcached
12209 b      20   0 92312  28m  16m S  279  0.2  63:28.45 httpd



%CPU is 4308 here and it's not the highest value.
i havent seen that on any previous kernel on the same server.

should i upgrade procps or downgrade kernel then to get proper values back? :)
or is it a feature of the new kernel?

thank you
