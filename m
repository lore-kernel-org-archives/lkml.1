Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbXHAVlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbXHAVlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbXHAVlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:41:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:43804 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbXHAVlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vje3xwIFvi3z25k7kBhcDVJefsFAsvZor0tdCPbhWLCFYfa9RzheI/NlZrc/QCuIo3yoEUeA5bz3xN3X3c4LQlMHo65a3Xc643JvGixCgwI5GmAZDla6twdcN3XqNEcpaKDbm+IdZYEIKOUd29iVTz/JKulTxzpGCeASYuj6ciA=
Message-ID: <29495f1d0708011441qe576ebdgb72d920989e114ca@mail.gmail.com>
Date: Wed, 1 Aug 2007 14:41:19 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Zan Lynx" <zlynx@acm.org>
Subject: Re: 2.6.22-rc1-mm1 huge pages VM freeze (maybe?)
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1185919297.6981.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185918261.6981.13.camel@localhost>
	 <20070731150245.5932b763.randy.dunlap@oracle.com>
	 <1185919297.6981.16.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Zan Lynx <zlynx@acm.org> wrote:
> On Tue, 2007-07-31 at 15:02 -0700, Randy Dunlap wrote:
> > On Tue, 31 Jul 2007 15:44:21 -0600 Zan Lynx wrote:
> >
> > > I was playing with huge pages and libhugetlbfs.  Small programs like
> > > "ls" work fine.  I tried running Evolution through libhugetlbfs and the
> > > system slowly stops running.  One interesting thing is the "ps" command,
> > > it gets stuck like this:
> >
> > Do you mean 2.6.22-rc1-mm1 or 2.6.23-rc1-mm1?
>
> D'oh!  I mean 2.6.23-rc1-mm1, the 22 was a typo.  Cut & paste to be
> sure:
> Linux zephyr 2.6.23-rc1-mm1 #1 SMP PREEMPT Wed Jul 25 17:33:04 MDT 2007
> x86_64 AMD Athlon(tm) 64 Processor 3400+ AuthenticAMD GNU/Linux

Also, are we at all sure this isn't a reiser4 issue? I assume you're
able to use Evolution w/o libhuge on rc1-mm1 ok? Any chance to remove
reiser4 from the picture? Have you been using libhuge this way
regularly? Any chance you know it worked ok with some recent kernel
(say 2.6.23-rc1?).

Thanks,
Nish
