Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbYHKSNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbYHKSNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYHKSNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:13:30 -0400
Received: from web82107.mail.mud.yahoo.com ([209.191.84.220]:48045 "HELO
	web82107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752729AbYHKSNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:13:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=uVX3/gLFOq/ggpmfjzDe2kaZi8uU5kcjNGpWYQJ3L/ozs0VoR5eAYFYWP5/z2DQaL+JtIZTJQr7VXZskEtu4do8zwAi4KLk3cYOqNcqiKB4MwB9/0kzLuDMKbxB015eYgy9WhXlD+xBg87N1JWE/C9a8OYU5pvPLATCJT3oWsVQ=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Mon, 11 Aug 2008 11:13:29 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: [PATCH diagnostic] Re: HPET regression in 2.6.26 versus 2.6.25 -- RCU problem
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <396862.4174.qm@web82107.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> So i find this debug feature rather useful and have applied it to 
> tip/core/rcu (and cleaned it up a bit). I renamed the config option to 
> CONFIG_DEBUG_RCU_STALL to make it more in line with usual debug option 
> names. Lets see whether -tip testing finds any false positives.

Hmmm, should have read ALL of the emails first!  Drat...

Just for kicks, I rebuilt using Ingo's version -- since I had manually
pasted Paul's patch, there was the possibility of PEBKAC interference:
no additional output at the lock up.


Dave W.
