Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbXHZPle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbXHZPle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 11:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbXHZPl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 11:41:26 -0400
Received: from mail.setcomm.ru ([81.211.32.179]:59330 "EHLO mail.setcomm.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbXHZPlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 11:41:25 -0400
X-Greylist: delayed 1572 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Aug 2007 11:41:25 EDT
Message-ID: <46D198FE.70506@kernelpanic.ru>
Date: Sun, 26 Aug 2007 19:15:10 +0400
From: "Boris B. Zhmurov" <bb@kernelpanic.ru>
Reply-To: bb@kernelpanic.ru
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Willy Tarreau <wtarreau@hera.kernel.org>, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org
Subject: Re: Linux 2.6.20.17
References: <20070825153810.GA32619@hera.kernel.org> <20070825110148.5fd59272.randy.dunlap@oracle.com>
In-Reply-To: <20070825110148.5fd59272.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Randy Dunlap.

On 25.08.2007 22:01 you said the following:


> I'm getting build errors:
> 
> x86_64 allyesconfig, allmodconfig:
> 
> drivers/ata/pata_atiixp.c:286: error: 'PCI_DEVICE_ID_ATI_IXP700_IDE' undeclared here (not in a function)
> net/bluetooth/rfcomm/tty.c:275: error: 'struct rfcomm_dev' has no member named 'tty_dev'
> net/bluetooth/rfcomm/tty.c:278: error: 'struct rfcomm_dev' has no member named 'tty_dev'


After applying patch-2.6.20.17, I'm getting build errors either:

net/bluetooth/rfcomm/tty.c: In function `rfcomm_dev_add':
net/bluetooth/rfcomm/tty.c:275: error: structure has no member named 
`tty_dev'
net/bluetooth/rfcomm/tty.c:278: error: structure has no member named 
`tty_dev'
make[3]: *** [net/bluetooth/rfcomm/tty.o] Error 1
make[2]: *** [net/bluetooth/rfcomm] Error 2
make[1]: *** [net/bluetooth] Error 2
make: *** [net] Error 2



-- 
Boris B. Zhmurov
mailto: bb@kernelpanic.ru

