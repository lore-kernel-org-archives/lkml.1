Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbXC1VTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbXC1VTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbXC1VTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:19:10 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:41827 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753055AbXC1VTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:19:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zawKcoYcPLuKzMD43emdofeWsKl8/n9gko0eJlvrZzua9xIYrAyyTq9qQMZNsfksNvoAcRxnPTc6yMkEsKfNidPEXbAtJm2iDbtBdAgvlWxEYMTOa0zE0H1MSfc2Ckbz1l2K6AxKJXoEnszyi8OhgWTLsKhe3C/6CYnPAYIn7OE=  ;
X-YMail-OSG: ZoSPLVQVM1l.KQORTfcnv.dZkR4LE74PBwJb43d5BGb06ky8loAPJTUi3oPj7R6Rq7y6x6jZ2w--
From: David Brownell <david-b@pacbell.net>
To: Maxim <maximlevitsky@gmail.com>
Subject: Re: [linux-pm] [3/6] 2.6.21-rc4: known regressions
Date: Wed, 28 Mar 2007 13:59:26 -0700
User-Agent: KMail/1.7.1
Cc: linux-pm@lists.linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>, linux-ide@vger.kernel.org,
       gregkh@suse.de, linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, linux-acpi@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, jgarzik@pobox.com,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703281238.57811.david-b@pacbell.net> <200703282220.00199.maximlevitsky@gmail.com>
In-Reply-To: <200703282220.00199.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703281359.29009.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2007 1:19 pm, Maxim wrote:
> On Wednesday 28 March 2007 21:38:55 David Brownell wrote:

> > 
> > Also, making HPET use the legacy mode seems like a step backwards.

> 	It is not 'legacy' mode,
> It is a legacy replacement mode.

Typo, sorry.


> It this mode HPET takes over IRQ0 and IRQ 8 and provides this way
> replacement for PIT and RTC periodic function 

It's that RTC periodic thing that bothers me, I don't mind about
the PIT.  Remember that IRQ8 is also used for other RTC functions.

Now, if there were a way to tell rtc-cmos that HPET is active,
and arrange some kind of handshake ... that would be different.

- Dave
