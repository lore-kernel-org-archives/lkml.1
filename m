Return-Path: <linux-kernel-owner+w=401wt.eu-S1751950AbZIGMhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbZIGMhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZIGMhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:37:07 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:54790 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZIGMhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UYFiKQL3fzZwRCVYoAOM9E+fd3PYvbRcn1nuWxwzxh1b00T51KgNoCfnIaSrKyurp2
         pwEbYXNinJTR7MP2nMVqh1elY40r/xBUu/O9PRL0LhdDzmEXAG6oaN7oRtFBitlClqYG
         W1GrZa/N4AnYHNhSy+92ozagjEHsDmI/QlI7w=
Subject: [PATCH 0/5] debugfs - Change default dir to mount debugfs for
	consistency.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Greg KH <greg@kroah.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Private
Date: Mon, 07 Sep 2009 21:36:59 +0900
Message-Id: <1252327019.2153.95.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From 1a6a1b8d86da5d3e938754f0f4e71aaf7813ef0f Mon Sep 17 00:00:00 2001
From: GeunSik,Lim <leemgs1@gmail.com>
Date: Mon, 7 Sep 2009 21:05:03 +0900
Subject: [PATCH 0/5] Change default dir to mount debugfs for consistency.

Change default dir to mount debugfs for consistency.
As we all know, We need change default directory for consistency of
debugfs by Greg Kroah Hartman. 



GeunSik,Lim (5):
  Fix mount directory of debugfs by default in events.txt
  Change debuhgfs directory of trace-events-sample.h
  Change debugfs directory of IWMC3200.
  Modified default mounting dir of debugfs for debugging UHCI.
  Modify default debugfs directory for debugging pktcdvd.

 Documentation/trace/events.txt             |   24 ++++++++++++------------
 drivers/block/pktcdvd.c                    |    2 +-
 drivers/net/wireless/iwmc3200wifi/Kconfig  |    6 +++---
 drivers/usb/host/uhci-hcd.c                |    2 +-
 samples/trace_events/trace-events-sample.h |    2 +-
 5 files changed, 18 insertions(+), 18 deletions(-)




-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

