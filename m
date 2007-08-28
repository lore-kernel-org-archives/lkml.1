Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbXH1NA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbXH1NA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXH1NAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:00:18 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:50239 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbXH1NAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:00:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pV9oE3Evg+KUQPOB7B/LvN26LnGKl+wTPj5okPeJ5jf158Wjg3HXzSL8y04JzQh/VOwPHTV1HclNoIAyrNU2ohW4bc/o4KwCXhdNdUiC2dwaCEO4jIqVT6JlQjdoE9GUO273bH3/xk73RWEPCt2Aj/XLf+P8zd+TuJ8UZP38Zh8=
Message-ID: <961aa3350708280600u3803015ehb45e4d7cdf318c69@mail.gmail.com>
Date: Tue, 28 Aug 2007 22:00:14 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Cc: "Pavel Machek" <pavel@ucw.cz>, "Jeff Chua" <jeff.chua.linux@gmail.com>,
       vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       "kernel list" <linux-kernel@vger.kernel.org>, satyam@infradead.org,
       ashok.raj@intel.com, ego@in.ibm.com, rusty@rustcorp.com.au
In-Reply-To: <200708281230.41774.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070827104350.GA2073@elf.ucw.cz> <200708272359.32484.rjw@sisk.pl>
	 <20070827215822.GH3398@elf.ucw.cz> <200708281230.41774.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/28, Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday, 27 August 2007 23:58, Pavel Machek wrote:
> > On Mon 2007-08-27 23:59:31, Rafael J. Wysocki wrote:
> > > On Monday, 27 August 2007 23:32, Pavel Machek wrote:
> > > > On Mon 2007-08-27 22:36:57, Jeff Chua wrote:
> > > > > On 8/27/07, Pavel Machek <pavel@ucw.cz> wrote:
> > > > > > On Mon 2007-08-27 12:43:50, Pavel Machek wrote:
> > > > > > > Hi!
> > > > > > >
> > > > > > > Trying to do few onlines/offlines reliably hangs my machine (thinkpad
> > > > > > > x60, i386 architecture).
> > > > >
> > > > > I just 3 cycles of on-line/off-line on 2.6.23-rc3 on ThinkPad x60s,
> > > > > and my system still survives.
> > > >
> > > > Can you try 20-or-so tests? Mine hangs randomly, so it survived 4 or
> > > > so cycles at one point.
> > > >
> > > > ...or maybe difference is in the .config, or maybe I broken something
> > > > in my kernel sources....

I have been doing enough CPU offline/online test these days and it works fine.
But there is no cpufreq driver which supports my machine. So my test didn't
cover test cpu hotplug code in cpufreq.

If you have cpufreq driver and it is built as module, it is worth trying
same test after unloading cpufreq driver in order to narrow down the problem
area.
