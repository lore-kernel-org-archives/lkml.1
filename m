Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZJWOYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZJWOYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZJWOYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZJWOYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:24:14 -0400
Subject: Re: request_module vs. modprobe blacklist (and security subsystem
 implications)
From: Eric Paris <eparis@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       randy.dunlap@oracle.com, andi@firstfloor.org, dhowells@redhat.com,
       akpm@linux-foundation.org
In-Reply-To: <200910231946.39174.rusty@rustcorp.com.au>
References: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com>
	 <200910221626.51170.rusty@rustcorp.com.au>
	 <1256221822.4443.95.camel@dhcp231-106.rdu.redhat.com>
	 <200910231946.39174.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Oct 2009 10:23:50 -0400
Message-Id: <1256307830.4443.158.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 19:46 +1030, Rusty Russell wrote:
> On Fri, 23 Oct 2009 01:00:22 am Eric Paris wrote:
> > > If a userspace program tries some security exploit that has been closed, do
> > > you want to warn about it?  Because that seems to be the question here.
> > 
> > I say yes.  Knowing that malicious activity is taking place, even if it
> > didn't hurt anything is useful.
> 
> Hi Eric,
> 
> Your proposal is troubling for three reasons:
> 
> 1) You would disable logging for things you actually want logged.

I would?

> 2) What *actually* happens when ssh tries to load ipv6 is that
>    "modprobe net-pf-10" gets called.
> 3) Containing modprobe behavior in one set of config files is really nice.

It is it also means that we, somewhat regularly call userspace
needlessly and there is nothing an admin can do to stop it.

But it appears you disagree that fixing that problem is worth it, and I
don't feel strongly enough to keep arguing  :)

-Eric


