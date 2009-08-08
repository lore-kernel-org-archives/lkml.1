Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbZHHVxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbZHHVxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 17:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZHHVxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 17:53:22 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:48587 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZHHVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 17:53:22 -0400
Message-ID: <1249768357.4a7df3a5a62f6@imp.free.fr>
Date: Sat, 08 Aug 2009 23:52:37 +0200
From: paniscus@free.fr
To: linux-kernel@vger.kernel.org
Subject: 2.6.26 : Strange processor / core mapping with Intel Q6600
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 64.103.25.233
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It seems that the cpu / core-id mapping has changed since vanilla 2.6.26 (also
2.6.26.8, 2.6.27.29) with an Intel Core 2 Quad Q6600.

With 2.6.25.20 I have a correct mapping :

Processor 0 <---> Core-id 0
Processor 1 <---> Core-id 1
Processor 2 <---> Core-id 2
Processor 3 <---> Core-id 3


With 2.6.26 :

I have a this strange mapping :

Processor 0 <---> Core-id 0
Processor 1 <---> Core-id 2
Processor 2 <---> Core-id 3
Processor 3 <---> Core-id 1

/proc/cpuinfo with 2.6.26 :


processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping	: 11
cpu MHz		: 1600.000
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
...
...

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping	: 11
cpu MHz		: 1600.000
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
...
...

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping	: 11
cpu MHz		: 1600.000
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
...
...

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping	: 11
cpu MHz		: 1600.000
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
...
...


I would appreciate it if you could help me on this. Is it maybe already an known
issue ?

regards,

-Franck.

