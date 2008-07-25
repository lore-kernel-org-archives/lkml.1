Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbYGYWWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbYGYWWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYGYWWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:22:06 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:42168 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751778AbYGYWWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:22:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iaZQz2Hd1ZFiNBNiMUlBch2S25NRZQxT/WmJu5aybTgeD2XQJ254zfo50hsXLWcPRBvQTPNbt8Nd8pcR+sIWp6dabGa83s5awI85oinJJ3+GZHePWBCG7nM3JXduT3FcmEAFcYDxHQQHbwMt/c3UqwBvHKcVWSr8o+81SDCa27Y=  ;
X-YMail-OSG: ga5XZTAVM1kLHAkJuZg7eST5sbvGG7ywiWd3F4wl4K.t4kQgjo2rIRUaRQ04dQODWEZNIZAuk6kw1.qCApernoM38Suulm_8Gnc6L7hrpWW8wqRNPU6theZKiUgi3Ej5ubQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.26-git] pm selftest:  rtc paranoia
Date: Fri, 25 Jul 2008 15:22:02 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <200807251326.51987.david-b@pacbell.net> <20080725144946.5e1b78c8.akpm@linux-foundation.org>
In-Reply-To: <20080725144946.5e1b78c8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251522.02789.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 July 2008, Andrew Morton wrote:
> On Fri, 25 Jul 2008 13:26:51 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Cope with a quirk of some RTCs (notably ACPI ones) which
> > aren't guaranteed to implement oneshot behavior when they
> > woke the system from sleeep:  forcibly disable the alarm,
> > just in case.
> > 
> > ...
> 
> I assume this fixes some reported bug?  Any references?

It's more paranoia than anything else ... I saw a version
of this with on x86, but that was because of problems in
the HPET glue (fixed by a previous patch).

 
> Is this needed in 2.6.26.x?  2.6.25.x?

The selftest only merged this week, so not 2.6.25;
and since it's just paranoia, it shouldn't be critical
for 2.6.26 either.

- Dave



