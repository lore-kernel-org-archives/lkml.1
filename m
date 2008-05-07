Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbYEGPCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbYEGPCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbYEGPC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:02:27 -0400
Received: from web32606.mail.mud.yahoo.com ([68.142.207.233]:41003 "HELO
	web32606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756933AbYEGPCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:02:24 -0400
X-YMail-OSG: J.bUVZwVM1mYaU5bRdzL6YV1ZL9OqL2VMkqE_miq2bEHE7gQJ3eFq1Tjt4LQTQHZCA--
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Wed, 7 May 2008 08:02:23 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <814762.71071.qm@web32606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Bart Van Assche <bart.vanassche@gmail.com>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: linux-kernel@vger.kernel.org; hmh@hmh.eng.br
> Sent: Wednesday, May 7, 2008 3:06:02 PM
> Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
> 
> On Wed, May 7, 2008 at 2:42 PM, Martin Knoblauch wrote:
> >
> >  any news on the one below? I upgraded to 2.6.25.2 and the problem still 
> persists. Would adding a bugzilla actually help ? :-)
> >
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0804.2/1144.html
> 
> I noticed a similar issue on 2.6.22 and 2.6.24 kernels: with ACPI
> disabled Linux' clock jumps backward and forward early during boot.
> See also the kernel messages from the attachment in comment #13 of
> http://bugzilla.kernel.org/show_bug.cgi?id=9936.
> 
> Bart,

Hi Bart,

 no this looks different. As soon as the timesource is detected, I see non-zero timestamps
in dmesg, but they look smaller and jump in both directions. And I have never seen this before
2.6.25.

 It actually might be a good idea to get the dmesg output from 2.6.24.

Cheers
Martin

