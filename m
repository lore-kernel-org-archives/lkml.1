Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbXKOVJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbXKOVJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932227AbXKOVJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:09:30 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:55773 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbXKOVJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:09:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rmz8o8ppRk/06zMaRaFYzIlNQY+1h/OtJADrkZujX4yMY2VnH5STVu09Kk76OabzwFkiNBIe6ADN9gVCkEn3JTO7N4xLvZO2QHx5r37TrBg9XSIBF8l/KaMPwXwbbGoecxTgAceYJ3+5rl4l8eLS/CnX/i7uZkoCxJNV0OJQB/I=
Message-ID: <5bdc1c8b0711151309q6a6b1de6q328710a3b009b3ec@mail.gmail.com>
Date: Thu, 15 Nov 2007 13:09:28 -0800
From: "Mark Knecht" <markknecht@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.24-rc2-rt1
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <Pine.LNX.4.58.0711151551570.27347@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195152030.13982.48.camel@localhost.localdomain>
	 <5bdc1c8b0711151241j5f1b8427w38d2a286eb6ebb7f@mail.gmail.com>
	 <Pine.LNX.4.58.0711151551570.27347@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sent.

On Nov 15, 2007 12:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> On Thu, 15 Nov 2007, Mark Knecht wrote:
>
> > On Nov 15, 2007 10:40 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > Finally!
> > >
> > > We are pleased to announce 2.6.24-rc2-rt1.
> > >
> > <SNIP>
> >
> > Hi Steve,
>
> <snip!>
>
> >
> >    As always thanks the the rt-kernel team for all you do.
>
> On behalf of the rt-kernel team, you are welcome ;-)
>
> >
> > Cheers,
> > Mark
> >
> >   CC      ipc/mqueue.o
> >   CC      ipc/compat_mq.o
> >   LD      ipc/built-in.o
> >   CC      security/security.o
> >   CC      security/dummy.o
> >   CC      security/inode.o
> >   LD      security/built-in.o
> >   CC [M]  security/commoncap.o
> >   CC [M]  security/realcap.o
> > security/realcap.c: In function 'realtime_exit':
> > security/realcap.c:129: error: implicit declaration of function
> > 'mod_unreg_security'
> > security/realcap.c:133: error: implicit declaration of function
> > 'unregister_security'
> > make[1]: *** [security/realcap.o] Error 1
> > make: *** [security] Error 2
> > lightning linux #
>
> Definitely looks like a config bug. You can send me your config off
> list.
>
> Hmm, I need to do a allyesconfig, but I'm not even sure 2.6.24-rc2 would
> compile with that.
>
> Thanks,
>
> -- Steve
>
