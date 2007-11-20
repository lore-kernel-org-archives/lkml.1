Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbXKTH0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbXKTH0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbXKTH0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:26:44 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:28841 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754606AbXKTH0n (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:26:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=b2tg/Qpycum0eozFlY9y7CZ0sht0pC8HlSxxIVmEkO49TNKq+ClXnhCr5eyjcDQ975gCMRpEu9O2Ao/28rMb8rVNa/PX4YYVftRIQ35cT9eX04iCzePS3roJk2sBgDqFBG4aClQM6AN4j+7oGRKJ5U4/ax0+AFEg+4vAYGXSkXE=  ;
X-YMail-OSG: uUDFd6YVM1lE87lDUAPLVAyxPs6_YuzoxP7OBhc5RcNy26F9mWpAZPPN7les5yWJ3L3zMKzLdw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG?] OOM with large cache....(x86_64, 2.6.24-rc3-git1, nohz)
Date: Tue, 20 Nov 2007 18:26:34 +1100
User-Agent: KMail/1.9.5
Cc: pomac@vapor.com, Linux-kernel@vger.kernel.org
References: <1195520355.8601.14.camel@localhost> <200711201513.36711.nickpiggin@yahoo.com.au> <20071120054648.GA20436@elte.hu>
In-Reply-To: <20071120054648.GA20436@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201826.35014.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 16:46, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Unfortunately, we don't show NR_ANON_PAGES in these stats, [...]
>
> sidenote: the way i combat these missing pieces of instrumentation in
> the scheduler is to add them immediately to the cfs-debug-info.sh script
> (and to /proc/sched_debug if needed). I.e. if we get one report that
> misses a piece of critical information is OK, but if it's two reports
> and we still havent made it easy to report the right kind of information
> that is our fault entirely. This constant ping-ponging for information
> that goes on for basically every MM problem - which information could
> have been provided in the first message (by running a single, easy to
> download tool) is getting pretty hindering i believe.

I do usually to add the stats as I've needed them. I haven't
specifically needed NR_ANON_PAGES for an oom-killer problem
before, but I've added plenty of other output there.

(it's in /proc/meminfo of course, which is the most useful...)
