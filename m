Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbXKOUlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbXKOUlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbXKOUlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:41:24 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:38479 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbXKOUlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:41:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i1mR8lE9wAssjFvACZ7ANxTHqqZzaRU5VugAnr43atf3n7QpPMYtolK8TMhYyuTxbPrN0zTSWnemIM1OfM05lAnJpS7jUZXK1rE38Kk4kxG+rFrLEqfBBSZO3+8HMiw4ClTOLvmXmIFek1a4vvv+JED4g+tb6OaexL2DteYwTWs=
Message-ID: <5bdc1c8b0711151241j5f1b8427w38d2a286eb6ebb7f@mail.gmail.com>
Date: Thu, 15 Nov 2007 12:41:21 -0800
From: "Mark Knecht" <markknecht@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.24-rc2-rt1
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <1195152030.13982.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195152030.13982.48.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 10:40 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Finally!
>
> We are pleased to announce 2.6.24-rc2-rt1.
>
<SNIP>

Hi Steve,
   Not sure I've ever posted on this list. Always looking to help out
at my low level.

   Anyway, I tried building the kernel. My 1st two attempts, done
running make menuconfig from scratch, didn't boot. I gave up on that
for now and tried using make oldconfig from my 2.6.23-rt1 kernel (I'm
so far behind!!) and ended up with this error. Not sure it's enough
for you to find the bug. If you want/need more or want the config file
let me know.

   I'm sure this is just me setting inappropriate bits but I figured I
might as well send along the info. >/dev/null if it's inappropriate
but let me know how to move forward if possible.

   As always thanks the the rt-kernel team for all you do.

Cheers,
Mark

  CC      ipc/mqueue.o
  CC      ipc/compat_mq.o
  LD      ipc/built-in.o
  CC      security/security.o
  CC      security/dummy.o
  CC      security/inode.o
  LD      security/built-in.o
  CC [M]  security/commoncap.o
  CC [M]  security/realcap.o
security/realcap.c: In function 'realtime_exit':
security/realcap.c:129: error: implicit declaration of function
'mod_unreg_security'
security/realcap.c:133: error: implicit declaration of function
'unregister_security'
make[1]: *** [security/realcap.o] Error 1
make: *** [security] Error 2
lightning linux #
