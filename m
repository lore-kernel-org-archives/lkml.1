Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbZCBAgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbZCBAgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 19:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbZCBAgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 19:36:07 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:49143 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZCBAgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 19:36:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=YiEUXo1Acj8icbPCPjUR19jyXpYQAn19mYxHroShnR9HdxIbXSQHgOULDY820tWI61
         J8SJp5S04scnrMez9d43zMJROt0buK8AdyNTJu6JDdVtZatr3leX5jOy3yd/dt/Xkn+t
         GINCct2Eb/RLlg6uRDAJecCbMf1dqC0n1T3uo=
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 00:36:03 +0000
Message-ID: <a5d9929e0903011636w6bff1032y28ab58c0ff8c8052@mail.gmail.com>
Subject: some tc commands fail on 2.6.29-rc6-git5, works on 2.6.28.7
From: Joao Correia <joaomiguelcorreia@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all

On a Fedora 9 box, with a 2.6.29-rc6-git5 compiled with the same
.config as the previously running 2.6.28.7, i get:

[root@duron ~]# /sbin/tc qdisc add dev eth2 handle ffff: ingress
[root@duron ~]# /sbin/tc filter add dev eth2 parent ffff: protocol ip
prio 50 u32 match ip src 0.0.0.0/0 police rate 30320kbit burst 500k
drop flowid :1
RTNETLINK answers: Invalid argument
We have an error talking to the kernel
[root@duron ~]# uname -a
Linux duron 2.6.29-rc6-git5 #3 SMP Sun Mar 1 00:02:56 WET 2009 i686
athlon i386 GNU/Linux
[root@duron ~]#

There is no information regarding this event on dmesg or /var/log/messages.
eth2 exists and is working properly, under 2.6.28.7 it works (without
complaints).

Please advise on what steps I may take to provide more information. I have
both kernel sources and availability to apply patches/recompile as needed.

Thank you very much for your time,
Joao Correia
Centro de Informatica
Universidade da Beira Interior
Portugal
