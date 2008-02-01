Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbYBASMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbYBASMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbYBASMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:12:08 -0500
Received: from n16b.bullet.scd.yahoo.com ([209.73.160.83]:48003 "HELO
	n16b.bullet.scd.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757280AbYBASMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:12:06 -0500
X-yahoo-newman-spamcop: yes
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 784382.85476.bm@rrr1.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=W9keE1YMTsibpoIEmJ410EQq6f1Pf9oNN96Y1cskf1XC/uxnE5IIhH3JcYDsDzJqK5mrjJBEWdN52y2Ic6QWETg3D19y4W49mlCNqc1E7nXLmQtynYi5sie/fd3tzYwS721sYOoQjAGxtaFgjcVonXUQ89j87lk17RzKTP2uWfY=;
X-YMail-OSG: Brfl0SUVM1mCwdfegdF5Cq95i0IG04x1Cdb2L4J1XgoRz3wING2X7IP9Qo4XY.vC5yk2dYcBvBw.Ux_PcwfnAV31Wftht9fTZXP1O1WRzfiNKfGSthvWfTscNienaw--
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.162
Date: Fri, 1 Feb 2008 23:41:39 +0530 (IST)
From: veerasena reddy <veerasena_b@yahoo.co.in>
Subject: how to get chance for user space process even when the kernel is utilizing 100% CPU.
To: "linux-kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <269793.73556.qm@web8403.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a requirement where i need to execute a user process even when the kernel is utilizing 100% of CPU time.

Actual scenario is as below:
i have a device on my board. this device keeps generating regular (for every 2secs) messages for a user process. the user process has to poll on the device for any message is there to read and get the message from the device. once the user process reads the message it will be removed in device and uses for further/subsequent messages.

I have a test case where i need to send so much traffic through my board such that the kernel will be utilizing 100% CPU time to process this data. At this time (when CPU is 100% utilized) the user space process is not getting scheduled even after a long duration (say 10 minutes to 45 minutes). Mean time the message buffer in the device is filled up and the device halts (aka controlled crash; the device firmware has been designed like this) as there is no more memory on the device.

To avoid this scenario of device's message queue getting filled up because of the user space process not reading them, could you please anyone suggest some technique for getting my user space process scheduled even when there is very heavy traffic as described above.

In simple, i can put my requirement like this:
    Is there any way i can get a user space process get scheduled in the above condition (kernel occupying 100% of CPU due to heavy traffic)

Thanks in Advance.

Regards,
Veerasena.


      Bollywood, fun, friendship, sports and more. You name it, we have it on http://in.promos.yahoo.com/groups  

