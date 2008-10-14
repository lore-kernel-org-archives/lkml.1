Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYJNXLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYJNXLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYJNXL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:11:28 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:22838 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751095AbYJNXL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:11:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GvAZksaflN9ozYOqNEprdfjNiGZj0kUgMZu5zrMvf/tHVGpK5SbqU9/86wBg1S4hGhoOIhECzqr+0xJyBDFIg5e63F8Wpr0kFl/dh97r0m48/eloFoT/p7rzigkzW2ISzpwb04CccLqtSt/8hNg65JwwitGXNUiJOTTPj5PiWGk=  ;
X-YMail-OSG: XgQ07JoVM1n6QHtqsfb6PUmVDC6..Ef4LEEiwg5BD8UQPgv3LKfRj6.eBsXWTaZ8XPk4m7J4CgF4aFD1BfIiiYreYM3uYzMyCJO2TDffJHnzeTdOT03F0HYgiVi0PJFz088-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [patch 0/2] deal with missing PNP RTC entries
Date: Tue, 14 Oct 2008 16:11:24 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Rik Theys <rik.theys@esat.kuleuven.be>, shr_msn@yahoo.com.tw,
       Adam Belay <abelay@mit.edu>, Chuck Ebbert <cebbert@redhat.com>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rene Herman <rene.herman@keyaccess.nl>
References: <200810141658.51928.bjorn.helgaas@hp.com>
In-Reply-To: <200810141658.51928.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810141611.25276.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 October 2008, Bjorn Helgaas wrote:
> Dave, I added the __initconst, and I also moved the printk down
> where it happens always, just so I could make it a dev_info().
> Let me know if that invalidates your Acked-by.

No prob.


> These patches do not fix the ed458df4 RTC wakealarm sysfs problem
> Rafael reported.  I have a proposal for that, too, but it depends
> on some other stuff in -mm, so I'll post it separately.

That's resolved in mainline already ... the other changes
(assuming they're what I've seen previewed already) just
move of the ACPI glue from drivers/acpi to drivers/rtc.
So there's no rush on that; the regression is resolved.

- Dave

