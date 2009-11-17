Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZKQLeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZKQLeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbZKQLeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:34:14 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:63902 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbZKQLeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:34:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=w+NTWz/Px99xRYtnInxCS1gihDuPZ2aHWtHCU8hnLOBg6w4DrTBsEk02RxCuLxlQlF
         YF6ib45UIFeZPVguBXNJMEiJ3gBOw6rmJIFJszaks+Q5II+3zP4HEAF+AbBQ4pMVYfBu
         qXI0VMuJa4qB6tcNVJlVoZINr2dFO6oxKyoO8=
Message-ID: <4B028A37.1010202@gmail.com>
Date: Tue, 17 Nov 2009 06:34:15 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>
CC: Linux Kernel Network Developers <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: net-next-2.6 compilation errors: missing wireless/i82593.h
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the past 9-10 days, net-next-2.6 has failed to compile.  In addition to
the errors and warnings already reported here last week, since Nov 12th
there has been another missing file.  I kept hoping it was temporary, but
no joy.

/home/administer/net-next-2.6/drivers/net/znet.c:107:29: error: wireless/i82593.h: No such file or directory
/home/administer/net-next-2.6/drivers/net/znet.c:133: error: field ‘i593_init’ has incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c: In function ‘znet_set_multicast_list’:
/home/administer/net-next-2.6/drivers/net/znet.c:235: error: invalid application of ‘sizeof’ to incomplete type ‘struct i82593_conf_block’
/home/administer/net-next-2.6/drivers/net/znet.c:235: error: invalid application of ‘sizeof’ to incomplete type ‘struct i82593_conf_block’
/home/administer/net-next-2.6/drivers/net/znet.c:235: error: invalid application of ‘sizeof’ to incomplete type ‘struct i82593_conf_block’
/home/administer/net-next-2.6/drivers/net/znet.c:235: error: invalid application of ‘sizeof’ to incomplete type ‘struct i82593_conf_block’
/home/administer/net-next-2.6/drivers/net/znet.c:235: error: invalid application of ‘sizeof’ to incomplete type ‘struct i82593_conf_block’
/home/administer/net-next-2.6/drivers/net/znet.c:235: error: invalid application of ‘sizeof’ to incomplete type ‘struct i82593_conf_block’
/home/administer/net-next-2.6/drivers/net/znet.c:247: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:248: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:249: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:250: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:251: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:254: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:255: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:256: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:259: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:260: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:261: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:262: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:265: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:266: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:267: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:268: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:271: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:274: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:277: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:278: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:281: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:282: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:283: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:284: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:285: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:286: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:289: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:290: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:291: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:294: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:297: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:298: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:299: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:300: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:301: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:302: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:303: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:304: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:307: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:310: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:311: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:312: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:315: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:316: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:317: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:318: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:319: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:320: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:323: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:324: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:325: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:326: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:327: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:328: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:329: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:330: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:333: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:334: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:340: error: dereferencing pointer to incomplete type
/home/administer/net-next-2.6/drivers/net/znet.c:345: error: invalid application of ‘sizeof’ to incomplete type ‘struct i82593_conf_block’
/home/administer/net-next-2.6/drivers/net/znet.c:346: error: invalid application of ‘sizeof’ to incomplete type ‘struct i82593_conf_block’
/home/administer/net-next-2.6/drivers/net/znet.c:346: error: invalid application of ‘sizeof’ to incomplete type ‘struct i82593_conf_block’
/home/administer/net-next-2.6/drivers/net/znet.c:346: error: invalid application of ‘sizeof’ to incomplete type ‘struct i82593_conf_block’
/home/administer/net-next-2.6/drivers/net/znet.c:347: error: invalid application of ‘sizeof’ to incomplete type ‘struct i82593_conf_block’
/home/administer/net-next-2.6/drivers/net/znet.c:348: error: ‘OP0_CONFIGURE’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:348: error: (Each undeclared identifier is reported only once
/home/administer/net-next-2.6/drivers/net/znet.c:348: error: for each function it appears in.)
/home/administer/net-next-2.6/drivers/net/znet.c:348: error: ‘CR0_CHNL’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c: In function ‘znet_tx_timeout’:
/home/administer/net-next-2.6/drivers/net/znet.c:512: error: ‘CR0_STATUS_0’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:514: error: ‘CR0_STATUS_1’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:516: error: ‘CR0_STATUS_2’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:518: error: ‘CR0_STATUS_3’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:522: error: ‘TX_LOST_CRS’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:525: error: ‘OP0_RESET’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c: In function ‘znet_send_packet’:
/home/administer/net-next-2.6/drivers/net/znet.c:549: error: ‘CR0_STATUS_0’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:583: error: ‘OP0_TRANSMIT’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:583: error: ‘CR0_CHNL’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c: In function ‘znet_interrupt’:
/home/administer/net-next-2.6/drivers/net/znet.c:612: error: ‘CR0_STATUS_0’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:617: error: ‘CR0_STATUS_1’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:619: error: ‘CR0_STATUS_2’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:621: error: ‘CR0_STATUS_3’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:626: error: ‘SR0_INTERRUPT’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:631: error: ‘SR0_EVENT_MASK’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:631: error: ‘SR0_TRANSMIT_DONE’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:632: error: ‘SR0_RETRANSMIT_DONE’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:633: error: ‘SR0_TRANSMIT_NO_CRC_DONE’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:638: error: ‘TX_OK’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:640: error: ‘TX_NCOL_MASK’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:642: error: ‘TX_LOST_CTS’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:642: error: ‘TX_LOST_CRS’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:644: error: ‘TX_UND_RUN’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:646: error: ‘TX_HRT_BEAT’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:648: error: ‘TX_MAX_COL’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:666: error: ‘SR0_RECEPTION’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:667: error: ‘SR0_STOP_REG_HIT’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:671: error: ‘CR0_INT_ACK’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c: In function ‘znet_rx’:
/home/administer/net-next-2.6/drivers/net/znet.c:688: error: ‘CR0_STATUS_2’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:747: error: ‘RX_RCV_OK’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:749: error: ‘RX_CRC_ERR’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:750: error: ‘RX_ALG_ERR’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:756: error: ‘RX_OVRRUN’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:758: error: ‘RX_SRT_FRM’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c: In function ‘znet_close’:
/home/administer/net-next-2.6/drivers/net/znet.c:814: error: ‘OP0_RESET’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c: In function ‘hardware_init’:
/home/administer/net-next-2.6/drivers/net/znet.c:859: error: ‘OP0_RESET’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:885: error: ‘OP0_CONFIGURE’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:885: error: ‘CR0_CHNL’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:893: error: ‘OP0_IA_SETUP’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:898: error: ‘OP0_RCV_ENABLE’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c: In function ‘update_stop_hit’:
/home/administer/net-next-2.6/drivers/net/znet.c:904: error: ‘OP0_SWIT_TO_PORT_1’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:904: error: ‘CR0_CHNL’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:907: error: ‘CR1_STOP_REG_UPDATE’ undeclared (first use in this function)
/home/administer/net-next-2.6/drivers/net/znet.c:909: error: ‘OP1_SWIT_TO_PORT_0’ undeclared (first use in this function)
make[3]: *** [drivers/net/znet.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/net] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2
