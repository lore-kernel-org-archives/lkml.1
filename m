Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbXHCDvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbXHCDvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 23:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbXHCDvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 23:51:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:58847 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbXHCDvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 23:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CEXMbqSmXYXSidIdgeF+OGh4aw7p3AZxjq/PdBmFUlueU9gH6K2ow9+QP7hvM98BHqnSnPkDjJ7ZZXagut8cktSDQnsw/dV+C/AA804vAhGM5k5by23ltY3PqzfzuVluNcxBWFO1ZR+HnvcdD6Qbn/SLYeUt8kisA4HiCOqpc2c=
Message-ID: <29495f1d0708022051j471fcdf4q8937364b9647e6ee@mail.gmail.com>
Date: Thu, 2 Aug 2007 20:51:38 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Zan Lynx" <zlynx@acm.org>
Subject: Re: 2.6.22-rc1-mm1 huge pages VM freeze (maybe?)
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1186018859.92039.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185918261.6981.13.camel@localhost>
	 <20070731150245.5932b763.randy.dunlap@oracle.com>
	 <1185919297.6981.16.camel@localhost>
	 <29495f1d0708010852p7a53a0a8ra5e8155a3bf12965@mail.gmail.com>
	 <1186018859.92039.5.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Zan Lynx <zlynx@acm.org> wrote:
> On Wed, 2007-08-01 at 08:52 -0700, Nish Aravamudan wrote:
> > On 7/31/07, Zan Lynx <zlynx@acm.org> wrote:
> > > On Tue, 2007-07-31 at 15:02 -0700, Randy Dunlap wrote:
> > > > On Tue, 31 Jul 2007 15:44:21 -0600 Zan Lynx wrote:
> > > >
> > > > > I was playing with huge pages and libhugetlbfs.  Small programs like
> > > > > "ls" work fine.  I tried running Evolution through libhugetlbfs and the
> > > > > system slowly stops running.  One interesting thing is the "ps" command,
> > > > > it gets stuck like this:
> > > >
> > > > Do you mean 2.6.22-rc1-mm1 or 2.6.23-rc1-mm1?
> > >
> > > D'oh!  I mean 2.6.23-rc1-mm1, the 22 was a typo.  Cut & paste to be
> > > sure:
> > > Linux zephyr 2.6.23-rc1-mm1 #1 SMP PREEMPT Wed Jul 25 17:33:04 MDT 2007
> > > x86_64 AMD Athlon(tm) 64 Processor 3400+ AuthenticAMD GNU/Linux
> >
> > Just to confirm, still happens with -mm2?
>
> No, it does not seem to.  Evolution runs OK.  ps, top, pmap all work
> fine.

Interesting.

> However, a couple of other things happened.  Could be unrelated or only
> loosely related.
>
> Evolution launches spamd (spamassassin) to filter junk mail.  spamd died
> and I have this in dmesg to show for it:
>
> VM: killing process spamd
>
> spamd would have inherited the libhugetlbfs.so environment variables.
> There are no other clues as to why it died though.

Interesting. Any chance spamd can be run manually with those env
variables, but with HUGETLB_VERBOSE=99 (and/or in gdb) to see what
happens to it?

> Also, immediately after launching evolution with libhugetlbfs, I got
> that USB bug where the mouse starts creating keyboard input.  I got some
> of these in dmesg:
> keyboard.c: can't emulate rawmode for keycode 240
>
> That could be pure coincidence, although I had been using the system
> almost all day before that, and it hadn't happened.

Had you started evolution w/o libhugetlbs at all before that?

It does seem like that would be coincidence.

Thanks,
Nish
