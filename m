Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbYFECiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbYFECiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 22:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762949AbYFECiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 22:38:06 -0400
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:32764 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760830AbYFECiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 22:38:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PadOZ9CPqIaywmZjdKWSdTQiAasIjqhOvLhZ1gcHwmHviI4nI2rb0QzR2X9x2S+P7+bn0FWvRJ4Z5oTONSh+VB9zmiltsd67QJ7HAMH2Tdm+jBC7cxAzjOnvF09Mdeny59CejHX/kAnI9VAkeOLlny2wsQGQUMI0JSn6fPbLi+w=  ;
X-YMail-OSG: tWum15IVM1mk49kT4fvuu07vfA5tkhc9SuSIHVdF5nmEsjHnciO_ffyiek.TTj7M4bBuYMCnElIVpvRwHTdcrFFgzrPrh54BnwfWsq233eU6s7V01isOeqV4M8o.LZEDPYQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/4] Fix forcedeth hibernate/wake-on-lan problems
Date: Wed, 4 Jun 2008 19:38:01 -0700
User-Agent: KMail/1.9.9
Cc: Tobias Diedrich <ranma+kernel@tdiedrich.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20080518125715.GA19229@yamamaya.is-a-geek.org> <200805271432.12881.david-b@pacbell.net> <20080531072036.GC5405@ucw.cz>
In-Reply-To: <20080531072036.GC5405@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806041938.02045.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2008, Pavel Machek wrote:
> 
> > Yeah; under ACPI, PCI does not act like it does everywhere else.
> > Nor does wakeup in general.
> > 
> > After sending patches to fix that for a couple years now, I'm
> > well past being tired of doing that.  I suggest it's overdue for
> > the ACPI team to get this part of their act together.
> 
> I'm afraid you expect too much from the acpi team.

I'm likewise "afraid" that may be too much to expect.

If that's true, it's going to be even harder making
the cross-platform Linux PM framework do what it needs
to do.  Having various devices (not just laptop lids or
power buttons, or RTC alarms) wake systems from low power
states is pretty fundamental to the "P" part of ACPI.
And it's not like wakeup events are unique to ACPI.


> If you can't merge 
> patches yourself, perhaps someone interested (Tobias? me?) can push
> them for you?

I kind of think the ACPI team needs to just become more
responsive.  They helped Windows do this stuff; why has
Linux only seen delays and obstacles in this area?


