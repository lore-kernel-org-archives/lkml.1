Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbXJ0Tw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbXJ0Tw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 15:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXJ0TwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 15:52:20 -0400
Received: from mx39.mail.ru ([194.67.23.35]:49982 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbXJ0TwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 15:52:19 -0400
X-Greylist: delayed 4057 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Oct 2007 15:52:18 EDT
Date: Sat, 27 Oct 2007 23:50:25 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidz@redhat.com, rhughes@redhat.com
Subject: Re: [PATCH] 2.6.24-rc1: ensure "present" sysfs attribute even if
	battery is absent
Message-ID: <20071027195025.GA3263@zarina>
Reply-To: cbou@mail.ru
References: <200710272054.31160.arvidjaar@mail.ru> <20071027184249.GA2982@zarina> <1193513524.2915.18.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1193513524.2915.18.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 03:32:04PM -0400, David Woodhouse wrote:
> On Sat, 2007-10-27 at 22:42 +0400, Anton Vorontsov wrote:
> > Well, PROP_PRESENT wasn't my idea, currently it's used by pmu and
> > olpc drivers becuase it's not trivial to register/unregister their
> > batteries on physical insertion/removal. I have some plans to teach
> > at least pmu batteries to not use PROP_PRESENT. I don't have any
> > OLPC, thus I can't convert it.
> 
> Actually it's not hard to do that.

I didn't say it's hard. But we don't have any interrupts for the
battery events, thus we have to implement polling.

> It was done this way in response to a
> request from the userspace side. IIRC.

Oh. Userspace tried to do something weird then, I think. Generally
it's just sane to unregister absent hardware.

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
