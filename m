Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYHKSWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYHKSWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbYHKSWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:22:23 -0400
Received: from web82104.mail.mud.yahoo.com ([209.191.84.217]:39337 "HELO
	web82104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751959AbYHKSWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:22:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=EVmOWdUqU2NgPlp8OeZb1uhs5qSbD7FIXcMa6d3gDBwkrju7L2snbwOIzdU81ztrdXd4qORpB3Km+C/yV8OsmmKb2dcy9kGMkpOsAY8PHQmnsBaDBsKGzlBzMPIYmHjUviQ82nb/8ZLPJfUPtosPfdGQmY+OSBW6EV9zsC2WzWg=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Mon, 11 Aug 2008 11:22:21 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: [PATCH diagnostic] Re: HPET regression in 2.6.26 versus 2.6.25 -- RCU problem
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <173065.89301.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > Well, I was hoping to see something interesting.  I ran it with parameters
> > "debug initcall_debug", and it locked up at the same place.  I let it for
> > 15 minutes, in case of some delayed reaction.  Nada.
> 
> Interesting.  The causes could be:
> 
> o    Scheduling-clock interrupts aren't happening, as Ingo suggested.

Does anyone have a short answer to this question:  Were the changes between
2.6.25 and 2.6.26 so major that interrupts are NOW being used that were not
being used before?

Again, I don't even pretend to understand the kernel's inner workings, but
2.6.25 _did_ work on this hardware... and with HPET enabled.


DW
