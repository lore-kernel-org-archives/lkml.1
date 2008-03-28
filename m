Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYC1Wan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYC1Wan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbYC1Wag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:30:36 -0400
Received: from n61.bullet.mail.sp1.yahoo.com ([98.136.44.37]:42922 "HELO
	n61.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754348AbYC1Waf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:30:35 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Mar 2008 18:30:35 EDT
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 991999.21756.bm@omp400.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=bdD+SJzDteLLOH8A7gM9tYOP3Yjw3aMsu9EAghhTIHn+NZ+Br8w1GcFQs82BTRSzN/KWi6OoUlAwOSJTLbplxnPDMzk+61m4qtfRatfInHOPkOkk7ECcxV72G8po5qbT/ih403i4g4PmI4V++5kxDPwg1Ads7M3HVJnY+47/WXM=;
X-YMail-OSG: HYBXKckVM1mLcZ0ZLE2WY6SSVRCKXaD2AQZ8hhEU
Date: Fri, 28 Mar 2008 19:24:48 -0300 (ART)
From: Luis Sousa <ls.luis_sousa@yahoo.com.br>
Subject: sata io freeze, 2.6.18 and also 2.6.24
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <739784.81690.qm@web46009.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been having consistent hard system freezes for a
long time, every 2 days or so, and finally decided to
move to the most recent stable kernel. Unfortunatelly
that didn't fix it. The freezes seem to be io-related;
they started since I moved my drive to sata. They seem
to happen mostly when there's an io-intensive operation,
like extracting a big archive; a reboot is needed.

Nothing ever shows up in the logs.

I'm using the following drive:

ATA device, with non-removable media
        Model Number:       MAXTOR STM3160215AS                     
        Serial Number:      6RA2TMJ4
        Firmware Revision:  3.AAD   

Linux localhost 2.6.24.4 #4 SMP Fri Mar 28 14:51:50 BRT 2008 i686 GNU/Linux

This is a 2-processor CPU:

# cat /proc/cpuinfo 
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 9
cpu MHz         : 3013.697
cache size      : 1024 KB

(same goes for processor : 1)

Sincerely,
--
Luis Sousa


      Abra sua conta no Yahoo! Mail, o único sem limite de espaço para armazenamento!
http://br.mail.yahoo.com/

