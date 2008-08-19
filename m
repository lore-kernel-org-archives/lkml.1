Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYHSMFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYHSMFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 08:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYHSMFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 08:05:06 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:58625 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbYHSME6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 08:04:58 -0400
X-Greylist: delayed 1786 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2008 08:04:57 EDT
Message-ID: <48AAAFEB.8020608@cetrtapot.si>
Date: Tue, 19 Aug 2008 13:35:07 +0200
From: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: iptables-1.4.0 with 2.6.26
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Trying to build iptables-1.4.0 with 2.6.26 kernel on x86 fails with:

hinkok@alala /tmp/iptables-1.4.0 $ make
Extensions found:
cc -O2 -Wall -Wunused -I"/lib/modules/2.6.26/build"/include -I"/lib/modules/2.6.26/source"/include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libxt_sctp_sh.o -c extensions/libxt_sctp.c
In file included from extensions/libxt_sctp.c:23:
/lib/modules/2.6.26/build/include/linux/netfilter/xt_sctp.h:68: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__sctp_chunkmap_is_clear'
/lib/modules/2.6.26/build/include/linux/netfilter/xt_sctp.h:80: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__sctp_chunkmap_is_all_set'
extensions/libxt_sctp.c: In function 'print_chunks':
extensions/libxt_sctp.c:416: warning: implicit declaration of function '__sctp_chunkmap_is_clear'
extensions/libxt_sctp.c:421: warning: implicit declaration of function '__sctp_chunkmap_is_all_set'
make: *** [extensions/libxt_sctp_sh.o] Error 1

I think it complains about the bool type.

Regards,
Hinko

-- 
ČETRTA POT, d.o.o., Kranj
Planina 3
4000 Kranj
Slovenia, Europe
Tel. +386 (0) 4 280 66 03
E-mail: hinko.kocevar@cetrtapot.si
Http: www.cetrtapot.si


