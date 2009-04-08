Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZDHXK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZDHXK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZDHXIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:08:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:21662 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbZDHXIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:08:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,157,1239001200"; 
   d="scan'208";a="129480647"
From: "Luck, Tony" <tony.luck@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Date: Wed, 8 Apr 2009 16:08:31 -0700
Subject: RE: [PATCH] tracing/syscalls: use a dedicated file header
Thread-Topic: [PATCH] tracing/syscalls: use a dedicated file header
Thread-Index: Acm4m46mDkCIULKaTgm7bK3bS/FMigAACZwAAACIhEA=
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39B2F73F4@orsmsx505.amr.corp.intel.com>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com>
 <1236955332-10133-2-git-send-email-fweisbec@gmail.com>
 <12c511ca0904061455k3f8a9cc8r25b7930f257ed922@mail.gmail.com>
 <20090408184058.GB6017@nowhere>
 <57C9024A16AD2D4C97DC78E552063EA39B2F707D@orsmsx505.amr.corp.intel.com>
 <alpine.DEB.2.00.0904081842500.12259@gandalf.stny.rr.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe that will give the scripts that parse "git log" output
> some grief as I don't see that tag ever used before.

It appears that any scripts that venture into the depths of
the git logs need to be quite flexible ... people have already
been quite creative about the tags used.  My favourite is

        "Acked-with-apologies-by:"

though the operatic possibilities of

        "Singed-off-by"

are also amusing.

Here's the current list with frequency counts:

 280098     Signed-off-by:
  13893     Acked-by:
   1234     Reported-by:
   1217     Reviewed-by:
   1135     Tested-by:
     74     Reported-and-tested-by:
     57     Signed-of-by:
     35     Suggested-by:
     30     Requested-by:
     30     Bisected-by:
     27     signed-off-by:
     24     Reported-and-bisected-by:
     22     Signed-Off-by:
     20     Pointed-out-by:
     18     Singed-off-by:
     15     Debugged-by:
     14     Noticed-by:
     13     Found-by:
     10     Spotted-by:
      9     Fixed-by:
      9     ACKed-by:
      8     Acked-off-by:
      7     Noted-by:
      7     Acked-and-tested-by:
      6     Submitted-by:
      6     Diagnosed-by:
      5     Inspired-by:
      4     Written-by:
      4     Tested-and-Acked-by:
      4     Sighed-off-by:
      4     Reported-and-Tested-by:
      4     Report-by:
      3     Tested-and-acked-by:
      3     SIgned-off-by:
      3     Signed-by:
      3     Pointed-to-by:
      3     Modified-by:
      3     Located-by:
      3     Ackde-by:
      2     Testted-by:
      2     Signed_off-by:
      2     Sigend-off-by:
      2     Screwed-up-by:
      2     Reviewd-by:
      2     Idea-by:
      2     Grudgingly-acked-by:
      2     Earlier-version-tested-by:
      2     Discovered-by:
      2     Cc: Acked-by:
      2     Ack'd-by:
      2     Ack-by:
      1     With comment fixes Signed-off-by:
      1     Verified-by:
      1     Triaged-by:
      1     This patch does kmalloc + memset conversion to kzalloc anSigned-off-by:
      1     their Signed-off-by:
      1     Tested-and-requested-by:
      1     Tested-and-reported-by:
      1     Test-by:
      1     Tentatively-acked-by:
      1     Suggestd-by:
      1     sSigned-off-by:
      1     Sogned-off-by:
      1     Sign-off-by:
      1     Signe-off-by:
      1     Signen-off-by:
      1     signef-off-by:
      1     Signed-pff-by:
      1     Signed-off-by-by:
      1     Signed-off-and-morning-tea-spilled-by:
      1     Signed-ff-by:
      1     Sight-catched-by:
      1     Siged-off-by:
      1     Serial-parts-Acked-by:
      1     Sent-by:
      1     Rewieved-by:
      1     Reviewed-off-by:
      1     Reveiewed-by:
      1     Requested-and-tested-by:
      1     Reproduced-by:
      1     Reported-tested-and-acked-by:
      1     Reported--by:
      1     Reported-Bisected-Tested-by:
      1     Reported- and tested-by:
      1     Reported-and-debugged-by:
      1     Reported-and-argued-for-by:
      1     Reported-and-acked-by:
      1     Repented-by:
      1     Reminded-by:
      1     Pointed-out-and-tested-by:
      1     Patch-dusted-off-by:
      1     Original-code-by:
      1     Original-by:
      1     ned-off-by:
      1     Narrowed-down-by:
      1     Mostly-acked-by:
      1     Most-Definitely-Acked-by:
      1     Most contributed and Signed-off-by:
      1     More-or-less-tested-by:
      1     Mentored-by:
      1     Lots of updates from http://lkml.org/lkml/2008/5/20/32 Reported-by:
      1     Laughed-at-by:
      1     Jffs2-bit-acked-by:
      1     igned-off-by:
      1     Identified-by:
      1     Heckled-for-on-IRC-by:
      1     From: Unichrome Project http://unichrome.sf.net, Erdi Chen, Thomas Hellstrom    Signed-off-by:
      1     Forwarded-by:
      1     Foreseen-by:
      1     Explain what we use Acked-by:
      1     Explained-by:
      1     Eventually-typed-in-by:
      1     echo Signed-off-by:
      1     Confirmed-by:
      1     Compile-tested-by:
      1     Checked-by:
      1     Caught-by:
      1     Bug-found-by:
      1     Bitten-by-and-tested-by:
      1     Bisected-and-tested-by:
      1     Bisected-and-requested-by:
      1     Bisected-and-reported-by:
      1     Based-on-original-patch-by:
      1     As the idea originated from GregKH, I leave his Signed-off-by:
      1     Approved-by:
      1     AOLed-by:
      1     Aked-by:
      1     actually use it.  Kill this dead code.      Signed-off-by:
      1     Ackey-by:
      1     Acked-with-apologies-by:
      1     Acked-the-tulip-bit-by:
      1     Acked-the-net-bits-by:
      1     Aced-by:
