Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYHOKea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYHOKea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYHOKeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:34:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:4937 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbYHOKeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=d45p3hc9FZUlTrE6am2tElk+oEjJCkKvLStS9T+r/FnSum1gexoKgP490Q0WTqk4mb
         lfwd9Bg1ikxwqK6mYZsRlh+BXDTtdeTSN50/6zYMnd6f5FqdtaGbK7/NXVRPjQQgpEPW
         mf4BE0CimUyVzyPfDJNws1/WKoYk4Hd3uJ4nk=
Message-ID: <6d291e080808150334r57afc86cm5b77f48a217e6afa@mail.gmail.com>
Date: Fri, 15 Aug 2008 05:34:15 -0500
From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Compile warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not that great at C and I don't quite have any time right now but
I figured someone else can fix this if I can't:

  LD      drivers/isdn/hardware/avm/built-in.o
  CC      drivers/isdn/hardware/eicon/divasi.o
  CC      drivers/isdn/hardware/eicon/idifunc.o
  CC      drivers/isdn/hardware/eicon/um_idi.o
  CC      drivers/isdn/hardware/eicon/dqueue.o
  CC      drivers/isdn/hardware/eicon/capimain.o
  CC      drivers/isdn/hardware/eicon/capifunc.o
  CC      drivers/isdn/hardware/eicon/message.o
drivers/isdn/hardware/eicon/message.c: In function 'connect_b3_req':
drivers/isdn/hardware/eicon/message.c:2685: warning: cast from pointer
to integer of different size
drivers/isdn/hardware/eicon/message.c:2747: warning: cast from pointer
to integer of different size
drivers/isdn/hardware/eicon/message.c:2781: warning: cast from pointer
to integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'connect_b3_res':
drivers/isdn/hardware/eicon/message.c:2884: warning: cast from pointer
to integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'manufacturer_res':
drivers/isdn/hardware/eicon/message.c:3783: warning: cast from pointer
to integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'nl_ind':
drivers/isdn/hardware/eicon/message.c:6823: warning: cast from pointer
to integer of different size
drivers/isdn/hardware/eicon/message.c: In function 'add_b23':
drivers/isdn/hardware/eicon/message.c:8451: warning: cast from pointer
to integer of different size
drivers/isdn/hardware/eicon/message.c:8503: warning: cast from pointer
to integer of different size
  CC      drivers/isdn/hardware/eicon/capidtmf.o
  CC      drivers/isdn/hardware/eicon/diva_didd.o
  CC      drivers/isdn/hardware/eicon/diddfunc.o

This was while compiling -rc3 with allyesconfig

-- 

-Stoyan
