Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXDDRkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXDDRkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXDDRkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:40:55 -0400
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:35511 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbXDDRky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:40:54 -0400
Message-ID: <4613E230.6080608@wolfmountaingroup.com>
Date: Wed, 04 Apr 2007 11:36:48 -0600
From: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20050921 Red Hat/1.7.12-1.4.1
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Latest e1000 7.3.20 driver busted with 2.6.20.4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


CC [M]  drivers/net/chelsio/mv88x201x.o
  CC [M]  drivers/net/chelsio/my3126.o
  LD [M]  drivers/net/chelsio/cxgb.o
  CC      drivers/net/e1000/e1000_main.o
drivers/net/e1000/e1000_main.c:1185:45: error: macro "INIT_WORK" passed 
3 arguments, but takes just 2
ared (first use in this function)
drivers/net/e1000/e1000_main.c:1184: error: (Each undeclared identifier 
is reported only once
drivers/net/e1000/e1000_main.c:1184: error: for each function it appears 
in.)
make[3]: *** [drivers/net/e1000/e1000_main.o] Error 1
make[2]: *** [drivers/net/e1000] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

Jeff
