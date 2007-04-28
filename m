Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbXD1Uit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbXD1Uit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXD1Uit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:38:49 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:5651 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbXD1Uir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bZq7ZHTC6CkQ+IR3PiXHkUQYo5F03qaf5y0DZe0OStnZTzTOba+VKNJRfselMf3caxOU5rDoX/ac0vPyJ11SH4ceFBEW9F/mOpTvEZx1hiNYURQC/Yh5w/i2Yhdl/DhRMqsRIJ+bCHJYXx6sgrjVZupBNi3zHVd+vXh8Qwkov98=
Message-ID: <5a4c581d0704281338w28227b13p52f3043a56af4945@mail.gmail.com>
Date: Sat, 28 Apr 2007 22:38:45 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [2.6.21-git2] sk_buff changes break Cisco VPN client
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

skb_set_timestamp I can figure out, but the rest is a bit
 too hard for me... if anyone has already an idea of how
 to fix this, I'd be most grateful.

Cisco VPN client builds and works fine under 2.6.21 vanilla.

thanks in advance for any input ! ciao,

[root@sandman ~]# ciscobuild
make -C /share/src/linux-2.6.21-git2
SUBDIRS=/download/linux/net/vpnclient modules
make[1]: Entering directory `/share/src/linux-2.6.21-git2'
  CC [M]  /download/linux/net/vpnclient/linuxcniapi.o
/download/linux/net/vpnclient/linuxcniapi.c: In function 'CniInjectReceive':
/download/linux/net/vpnclient/linuxcniapi.c:299: warning: implicit
declaration of function 'skb_set_timestamp'
/download/linux/net/vpnclient/linuxcniapi.c:333: error: 'struct
sk_buff' has no member named 'nh'
/download/linux/net/vpnclient/linuxcniapi.c:334: error: 'struct
sk_buff' has no member named 'mac'
/download/linux/net/vpnclient/linuxcniapi.c: In function 'CniInjectSend':
/download/linux/net/vpnclient/linuxcniapi.c:456: error: 'struct
sk_buff' has no member named 'mac'
/download/linux/net/vpnclient/linuxcniapi.c:457: error: 'struct
sk_buff' has no member named 'nh'
/download/linux/net/vpnclient/linuxcniapi.c:460: error: 'struct
sk_buff' has no member named 'h'
/download/linux/net/vpnclient/linuxcniapi.c:460: error: 'struct
sk_buff' has no member named 'nh'
make[2]: *** [/download/linux/net/vpnclient/linuxcniapi.o] Error 1
make[1]: *** [_module_/download/linux/net/vpnclient] Error 2
make[1]: Leaving directory `/share/src/linux-2.6.21-git2'
make: *** [default] Error 2

--alessandro

 "Did you get married but forgot to get divorced ?"

     (Danny and Dusty, 'The Good Old Days')
