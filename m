Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbZCMH0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbZCMH0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZCMHZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:25:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:26309 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZCMHZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=eD2WceiwBlo22samHbJ5ua1P4lJDdZ/qwBQDLd/rkSL1POSujjyrVSuHBXgjolzDNT
         Vw9noDyydWLN1iqeTrgBUf0EjI5dBeEZ24+8KffKZXuoYKdqP+D6ScLjtTWMkS/zbg6M
         en32RZSZ5GnLbMKXUu62YIpDVmnLeORqgU/w8=
MIME-Version: 1.0
Date: Fri, 13 Mar 2009 00:25:48 -0700
Message-ID: <59f1f0cb0903130025k31cc2c9fud865dd776534c2bd@mail.gmail.com>
Subject: Network throughput (localhost)
From: Aki Niimura <akineko@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linux experts,

I developed a Python program, which tries to take advantage of
available Multi CPU resources.
Two programs (Server and Client) are running in separate processes
communicating each other using Socket IPC.
The performance I'm getting is somewhat in line with my expectation
under Solaris/x86 but significantly slower
under Linux (CentOS 5) even both use the identical hardware.

My investigation revealed that the performance is bottlenecked by the
communication (Socket to localhost).

So, I wrote much simpler program (socket server and socket client) to
measure the network throughput.
What I found was that the network throughput on both platforms
(Solaris/x86 and CentOS Linux) are almost
identical if packets are going out but the network throughput of
Solaris/x86 is almost twice (up to three times)
the throughput Linux can deliver if the packets are destined to localhost.

I know that Solaris treats packets destined to localhost differently.

Because of this, my program is slower (than one process) under Linux
(and is practically useless).
(I see meaningful performance gain under Solaris/x86, though)
I haven't tried any other Linux distributions.
Is there any Linux distribution known for better localhost network throughput?
Is there any way to improve the localhost throughput under Linux (CentOS)?

Of course, some people would point out that other types of IPC (such
as shared memory) are better choices
for the communication between closely coupled multi-processing
program. Unfortunately, there are
reasons that my program needs to use Socket.

Any suggestions will be greatly appreciated.

Best regards,
Aki Niimura
