Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYBDFuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYBDFuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 00:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYBDFuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 00:50:46 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3852 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbYBDFup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 00:50:45 -0500
X-Server-Uuid: A6C4E0AE-A7F0-449F-BAE7-7FA0D737AC76
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: (no subject)
Date: Sun, 3 Feb 2008 21:41:23 -0800
Message-ID: <E06E3B7BBC07864CADE892DAF1EB0FBD049E778C@NT-SJCA-0752.brcm.ad.broadcom.com>
In-Reply-To: <416607.4159.qm@web8406.mail.in.yahoo.com>
Thread-Topic: (no subject)
Thread-Index: Achk/nZNV5d8tkTXQPm2kxAavxWLGwB8ea2w
References: <416607.4159.qm@web8406.mail.in.yahoo.com>
From: "Ramgopal Kota" <rkota@broadcom.com>
To: "veerasena reddy" <veerasena_b@yahoo.co.in>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mips" <linux-mips@linux-mips.org>
X-WSS-ID: 6BB8781B3B01705449-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

You can set a real-time priority to the user-process.

Ramgopal Kota 
-----Original Message-----
From: linux-mips-bounce@linux-mips.org
[mailto:linux-mips-bounce@linux-mips.org] On Behalf Of veerasena reddy
Sent: Friday, February 01, 2008 11:45 PM
To: linux-kernel.org; linux-mips
Subject: (no subject)

Hi,

I have a requirement where i need to execute a user process even when
the kernel is utilizing 100% of CPU time.

Actual scenario is as below:
I have a device on my board. this device keeps generating regular (for
every 2secs) messages for a user process. the user process has to poll
on the device for any message is there to read and get the message from
the device. once the user process reads the message it will be removed
in device and uses for further/subsequent messages.

I have a test case where i need to send so much traffic through my board
such that the kernel will be utilizing 100% CPU time to process this
data. At this time (when CPU is 100% utilized) the user space process is
not getting scheduled even after a long duration (say 10 minutes to 45
minutes). Mean time the message buffer in the device is filled up and
the device halts (aka controlled crash; the device firmware has been
designed like this) as there is no more memory on the device.
To avoid this scenario of device's message queue getting filled up
because of the user space process not reading them, could you please
anyone suggest some technique for getting my user space process
scheduled even when there is very heavy traffic as described above.

In simple, i can put my requirement like this:
    Is there any way i can get a user space process get scheduled in the
above condition (kernel occupying 100% of CPU due to heavy traffic)

Thanks in Advance.

Regards,
Veerasena.


      Now you can chat without downloading messenger. Go to
http://in.messenger.yahoo.com/webmessengerpromo.php



