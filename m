Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbYHVBY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbYHVBY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 21:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYHVBYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 21:24:16 -0400
Received: from web82106.mail.mud.yahoo.com ([209.191.84.219]:26280 "HELO
	web82106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752394AbYHVBYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 21:24:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=eddeyowp/t7yxxP3Z6b73K1YeSgQFqW4P/pJrUW0vtxsbY8rz2VPSg3+BBiQw3x+IBgrFPaad3E6qwPIoOj78Y5cLG2PLHsUqF6ktmdSh9evFIkWRQATA8R7D7fuClR3joCqtSjM14ycN28HkdYcCZwBkQmqsIUmTkM9wnYzGTg=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Thu, 21 Aug 2008 18:24:15 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
       Bill Fink <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <165480.52635.qm@web82106.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> insert_resource/request_resource works well
> 
> can you verify if hpet work on old kernel?
> 
> cat /proc/timers*

$ ls /proc/t*
/proc/timer_list

/proc/tty:
driver    drivers  ldisc    ldiscs

$ grep -B 1 -A 5 hpet /proc/timer_list 
Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   149983005959
 min_delta_ns:   3352
 mult:           61496114
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000


If there's anything else I can do, just ask!
Dave W.
