Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbYFHXFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbYFHXFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 19:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbYFHXFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 19:05:37 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:40610 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755632AbYFHXFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 19:05:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KD0ZnqSuqb+mGlYdVxCsolb5s+DINHwWIM1ZfqR/8kl/EXO3Zu93YwH4TzKfuzMpaohd/4070AOD4k+Wkct43VT/ZtRbH55j8r1TqN3mQuUqczNSuxhZah6ilz1QEfQKCUGHpuZxTakGoB2ls1PWnOkj9+C8EV+YvVwqPdMDpqM=  ;
X-YMail-OSG: u6uprLgVM1kUt5nTuRH6L1Thk_.FMpmkYSG7l7Vw740nZsU49ywrtG3DvghWnR6LLD3x6hEqBBLzSxljd.OBTRkIRou21VTXqtPfolfsa4FiugghpRLOsqyONvrn_GldNTw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.26-rc5] make HPET_RTC_IRQ track HPET_EMULATE_RTC
Date: Sun, 8 Jun 2008 16:05:34 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
References: <200806052241.44713.david-b@pacbell.net> <20080608140011.aa3762cd.akpm@linux-foundation.org>
In-Reply-To: <20080608140011.aa3762cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081605.35042.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 June 2008, Andrew Morton wrote:
> On Thu, 5 Jun 2008 22:41:44 -0700 David Brownell <david-b@pacbell.net> wrote:
> 
> > More Kconfig tweaks related to the legacy PC RTC code:
> > 
> >  - Describe the legacy PC RTC driver as such ... it's never quite
> >    been clear that this driver is for PC RTCs, and now it's fair
> >    to call this the "legacy" driver.
> > 
> >  - Force it to understand about HPET stealing its IRQs ... kernel
> >    code does this always when HPET is in use, there should be no
> >    option for users to goof up the config.
> > 
> > This seems to fix kernel bugzilla #10729.
> 
> hm.  "seems" is a bit soft.

Fixes it for one reporter.  Another reporter has yet to respond.


> Do you think this should be in 2.6.26?

Yes, unless someone more involved in the HPET stuff has a better
solution.  (Or that legacy RTC gets a maintainer, who disagrees...)

This does seem to suggest that we have an extra Kconfig variable
here, by the way.

- dave



