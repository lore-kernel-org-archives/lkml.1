Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbXCKN33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbXCKN33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXCKN33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:29:29 -0400
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:38410 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752209AbXCKN33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:29:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3pdt/SOVYnjAI8usCWfdHXLoPth2zcaC2BpQoh7icM95o32TOXmpscNyYp3zC4l5WqOAtd24a6+KYM3fIoojQdtJKzP/kY+8iA3i420/Q3sjLKlOz7XXjXUNv/D22H0AIsfmSvfedP+HpWF/z0pJl6skVdKJ5Uo8boW6O8zsJYk=;
X-YMail-OSG: aftGpHgVM1msVtsQvSVuoiqFuCdK.yHI0C4wFEkCw6.VVvSKS9Fhmg1YvafxMZUfXuE7H9FTSO2hjdjOg4_KPmpFImKUUecHh7mV3ZIG2SAWrvSkJVOHJG6VMjv84sow9oTrs6fR3F9Y_XU-
Date: Sun, 11 Mar 2007 06:29:28 -0700 (PDT)
From: Parav Pandit <paravpandit@yahoo.com>
Subject: Locking interrupt handler in L1 cache
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <265904.11493.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have MPC 8548 Linux 2.6.x based firewall which will
mostly do packet processing for 80% time.
So obviously most of the time it will RX and TX
packets through gianfar ethernet driver.

I want to lock my interrupt handler of this driver in
the L1 cache.

1. Is there any kernel API for locking function and
data to lock them in the L1/L2 cache?

2. How can I use "icbtls" - Instruction Cache Block
Touch and Lock Set" for locking my interrupt handler?

3. Is "icbtls" is the correct instruction at which I
am looking at?

4. How do I find end address of the interrupt handler
function and how do we pass it to cache locking
instructions? (Because it can happen that interrupt
handler size is more than a cache line, not aligned
etc)?

5. Can we enhance request_irq() function to take an
additional parameter to lock the interrupt handler in
the cache?

I understand that if my interrupt handler is going to
be called most of the time then it is very likely to
happen that OS will flush the same, but there is no
guarantee for it.

Regards,
Parav Pandit



 
____________________________________________________________________________________
Get your own web address.  
Have a HUGE year through Yahoo! Small Business.
http://smallbusiness.yahoo.com/domains/?p=BESTDEAL
