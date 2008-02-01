Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYBASL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYBASL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYBASLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:11:52 -0500
Received: from n7.bullet.re3.yahoo.com ([68.142.237.92]:20584 "HELO
	n7.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751650AbYBASLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:11:52 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 242099.81377.bm@rrr2.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=PE3FJGT5J+JHNMlNOgIlehNuS/fCoBInwOfpzJ0x5rkJ/lUu0fddibBdTiOBx83fVWu9bny9trW6oTTIbKDetnl00/2oQ0Z5m/ELaOfOVLpzYDFLB1u/320O3chdthr1uPXVwUHMp3ZUrTGHKSGbE8Q49Ao0wASimpFN6NuZw/w=;
X-YMail-OSG: ZckXvHEVM1kTjHGqu9mMZ8vq91mcjDsideP.O8s4pnvwg7KbTnKk1h.jqI4GGeC8onnUA9_Jd6emblbfRef7_xzzD3H.qo1xhuJj.e35v2MhuHGub77l_tnkyLmC1A--
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.162
Date: Fri, 1 Feb 2008 23:41:48 +0530 (IST)
From: veerasena reddy <veerasena_b@yahoo.co.in>
Subject: how to get chance for user space process even when the kernel is utilizing 100% CPU.
To: "linux-kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <380904.30308.qm@web8401.mail.in.yahoo.com>
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


      Get the freedom to save as many mails as you wish. To know how, go to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html

