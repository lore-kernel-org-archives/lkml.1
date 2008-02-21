Return-Path: <linux-kernel-owner+w=401wt.eu-S933716AbYBUQWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716AbYBUQWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764646AbYBUQWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:22:05 -0500
Received: from mail2.i-o.com ([64.129.169.234]:44025 "EHLO barracuda.i-o.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764282AbYBUQWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:22:04 -0500
X-ASG-Debug-ID: 1203610877-6112028c0000-xx1T2L
X-Barracuda-URL: http://spamgateway2.iongeo.com:8000/cgi-bin/mark.cgi
X-MessageTextProcessor: DisclaimIt (2.70.271) [Input/Output Inc., Stafford, TX, USA]
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.2992
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-ASG-Orig-Subj: RE: Possible Serial Kernel Bug
Subject: RE: Possible Serial Kernel Bug
Date: Thu, 21 Feb 2008 10:21:10 -0600
Message-ID: <C35C6F42A97E0C468C32F3AEE46CFF6403C900FD@digiexch03.iodigi.ioroot.tld>
In-Reply-To: <47BDA02B.9090702@student.tuwien.ac.at>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Possible Serial Kernel Bug
thread-index: Ach0ov/PiSevpZpwS020RWeOwoXSdAAAhwKg
References: <C35C6F42A97E0C468C32F3AEE46CFF6403C07989@digiexch03.iodigi.ioroot.tld> <47BDA02B.9090702@student.tuwien.ac.at>
From: "Raynard Brown" <Raynard.Brown@iongeo.com>
Importance: normal
To: "Oliver Martin" <oliver.martin@student.tuwien.ac.at>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Feb 2008 16:21:17.0304 (UTC) FILETIME=[C9239F80:01C874A5]
X-Barracuda-Connect: UNKNOWN[10.50.10.14]
X-Barracuda-Start-Time: 1203610877
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at i-o.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

I tried disabling flow control on the server with stty -F /dev/ttyS2
-crtscts, then echo sometext > /dev/ttyS2, but I get the same results
the echo command freezes will trying to send data to the client.

Raynard

-----Original Message-----
From: Oliver Martin [mailto:leromarinvit@gmail.com] On Behalf Of Oliver
Martin
Sent: Thursday, February 21, 2008 10:01 AM
To: Raynard Brown
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possible Serial Kernel Bug

Raynard Brown schrieb:
> 0: uart:16550A port:000003F8 irq:4	tx:72	rx:6
> 1: uart:16550A port:000002F8 irq:3	tx:59	rx:6
> 2: uart:16550A port:000003E8 irq:11	tx:0	rx:0 RTS|DTR
> 3: uart:16550A port:000002E8 irq:10	tx:0	rx:0 RTS|DTR
> 4: uart:16550A port:000004F8 irq:0	tx:59	rx:6
> 
                                                      ^^^^^^^
Could it be that hardware flow control is enabled on the server, while 
it is disabled on the other side? What happens if you disable it with 
stty -F /dev/ttySX -rtscts?

Oliver

This email and any files transmitted with it are confidential and are intended solely for the use of the individual or entity to whom they are addressed.  If you are not the original recipient or the person responsible for delivering the email to the intended recipient, be advised that you have received this email in error, and that any use, dissemination, forwarding, printing, or copying of this email is strictly prohibited. If you received this email in error, please immediately notify the sender and delete the original.


