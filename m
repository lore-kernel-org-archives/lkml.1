Return-Path: <linux-kernel-owner+w=401wt.eu-S1761989AbYBUPl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761989AbYBUPl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbYBUPlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:41:17 -0500
Received: from mail2.i-o.com ([64.129.169.234]:36985 "EHLO barracuda.i-o.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753759AbYBUPlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:41:16 -0500
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 10:41:16 EST
X-ASG-Debug-ID: 1203607510-3e54030c0000-xx1T2L
X-Barracuda-URL: http://spamgateway2.iongeo.com:8000/cgi-bin/mark.cgi
X-MessageTextProcessor: DisclaimIt (2.70.271) [Input/Output Inc., Stafford, TX, USA]
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.2992
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-ASG-Orig-Subj: Possible Serial Kernel Bug
Subject: Possible Serial Kernel Bug
Date: Thu, 21 Feb 2008 09:24:48 -0600
Message-ID: <C35C6F42A97E0C468C32F3AEE46CFF6403C07989@digiexch03.iodigi.ioroot.tld>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Possible Serial Kernel Bug
thread-index: Ach0neUX0t/bZrLMQ8GLMCyNLqyNAw==
Importance: normal
From: "Raynard Brown" <Raynard.Brown@iongeo.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Feb 2008 15:25:10.0339 (UTC) FILETIME=[F2458930:01C8749D]
X-Barracuda-Connect: UNKNOWN[10.50.10.14]
X-Barracuda-Start-Time: 1203607510
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at i-o.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am currently using Red Hat Enterprise Linux 4 (Kernel Version 2.6.9)
and I wanted to start evaluating Red Hat Enterprise Linux 5 (Kernel
Version 2.6.18) for a possible migration. During my testing of Red Hat
5, I ran into a problem trying to communicate with a couple of the
serial ports on my machine. My serial ports tests are as simple as
connecting my Red Hat machine to a laptop running HyperTerminal with the
following settings:

Baud Rate: 19200
Data Bits: 8
Parity: None
Stop Bits: 1
Flow Control: None

If I run the follow command echo sometext > /dev/ttySX (where X is the
port I am trying to communicate with) on my Red Hat 4 installation I get
expected results (i.e. I see sometext being echoed on the HyperTerminal
application). I get the same results for all five ports on my Red Hat 4
installation. Similarly if I try to read data from these ports using the
command cat /dev/ttySX (where X is the port I am trying to communicate
with) I am able to read anything that is typed into the HyperTerminal
window. However if I install Red Hat 5 on this same machine and try the
following test I get strange results. I can send data to HyperTerminal
using ttyS0, ttyS1, ttyS4, but if I try to send data using ttyS2 or
ttyS3, the echo command locks up. Nothing is changed hardware wise for
the installation of Red Hat 5 (which was a clean installation not an
upgrade). I have also tried booting with a Fedora 8 Live CD Kernel
Version 2.6.23 and Ubuntu 7.04 Kernel version 2.6.20 and echo locks up
when trying to send data on ports ttyS2 and ttyS3 just like in Red Hat
5. 

Here is my serial port configuration output using setserial:

/dev/ttyS0, UART: 16550A, Port: 0x03f8, IRQ: 4
/dev/ttyS0, UART: 16550A, Port: 0x02f8, IRQ: 2
/dev/ttyS0, UART: 16550A, Port: 0x03e8, IRQ: 11
/dev/ttyS0, UART: 16550A, Port: 0x02e8, IRQ: 10
/dev/ttyS0, UART: 16550A, Port: 0x04f8, IRQ: 0

Here is the output from /proc/tty/driver/serial

0: uart:16550A port:000003F8 irq:4	tx:72	rx:6
1: uart:16550A port:000002F8 irq:3	tx:59	rx:6
2: uart:16550A port:000003E8 irq:11	tx:0	rx:0 RTS|DTR
3: uart:16550A port:000002E8 irq:10	tx:0	rx:0 RTS|DTR
4: uart:16550A port:000004F8 irq:0	tx:59	rx:6



My system has the following hardware

Motherboard: IEI Technology Corp, IMBA-8650
Memory: 2GB of Crucial CT12864Z40B
Processor: Intel Pentium 4 3.00GHz
Hard Drive: 250GB Western Digital WD2500KS
Serial Ports: 5

Any help will in resolving this matter would be appreciated. Can you CC
me when you respond to this post if it is not too much trouble.

Thanks,

Raynard

This email and any files transmitted with it are confidential and are intended solely for the use of the individual or entity to whom they are addressed.  If you are not the original recipient or the person responsible for delivering the email to the intended recipient, be advised that you have received this email in error, and that any use, dissemination, forwarding, printing, or copying of this email is strictly prohibited. If you received this email in error, please immediately notify the sender and delete the original.


