Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYG3JCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYG3JCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYG3JB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:01:57 -0400
Received: from mailout07.t-online.de ([194.25.134.83]:45578 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYG3JB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:01:57 -0400
From: =?iso-8859-1?q?J=FCrgen_Mell?= <j.mell@t-online.de>
Reply-To: j.mell@t-online.de
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rt1
Date: Wed, 30 Jul 2008 11:01:32 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
       "rt-users" <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Carsten Emde <ce@ceag.ch>
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807291440240.14925@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_s3CkIMJdBqs4Bx0"
Message-Id: <200807301101.32417.j.mell@t-online.de>
X-ID: bKjqb6ZbQh9JbOqL8liSG-GRD8QY8xxnRP06aRCZhm9kkUik2sKVmho+45J1dIsgxt
X-TOI-MSGID: 03e852b2-428a-43ef-bdd6-d48b1df2fe15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_s3CkIMJdBqs4Bx0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello Thomas,

On Wednesday, 30. July 2008, Thomas Gleixner wrote:
> We are pleased to announce the 2.6.26-rt1 tree, which can be
> downloaded from the location:

I have tried the new kernel and have some good news and some bad news:

The good news: The machine boots and seems to run without major problems.

The bad news: It produces continuously lots of bug messages in the error=20
logs (cf. attached dmesg.tgz). The error at rtmutex.c:743 was already=20
present in 2.6.25-rt* when ACPI was enabled. The 'using smp_processor_id=20
()  in preemptible code' is new here with 2.6.26.

Machine is an old Athlon XP (single core) on an EPOX mainboard with VIA=20
chipset.

If I can help with testing, please let me know.

Bye,
         J=FCrgen



--Boundary-00=_s3CkIMJdBqs4Bx0
Content-Type: application/x-tgz;
  name="dmesg.tgz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dmesg.tgz"

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

--Boundary-00=_s3CkIMJdBqs4Bx0--
