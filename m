Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbZKDXpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbZKDXpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932752AbZKDXpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:45:18 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:11312 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932635AbZKDXpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:45:17 -0500
Date: Thu, 5 Nov 2009 02:45:19 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] power: pcf50633: properly reenable charging when
 the supply conditions change
Message-ID: <20091104234519.GA4587@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
 <1257369899-325-2-git-send-email-fercerpav@gmail.com>
 <1257369899-325-3-git-send-email-fercerpav@gmail.com>
 <1257369899-325-4-git-send-email-fercerpav@gmail.com>
 <1257369899-325-5-git-send-email-fercerpav@gmail.com>
 <20091104214622.GA27325@elf.ucw.cz>
 <20091104222431.GB24196@home.pavel.comp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091104222431.GB24196@home.pavel.comp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 01:24:31AM +0300, Paul Fertser wrote:
[...]
> > If you want to "top-up" the battery, perhaps that should be on
> > explicit request, like something in /sys?
> 
> Well, probably but to me it seems like an unnecessary complexity. Also
> since Li* batteries are dominating the market nowadays this
> functionality would need to be introduced in the power_supply core to
> provide userspace with a consistent interface. Anton, can you please
> comment on this?

Power supply class doesn't have writeable properties (initially
it was a 'battery monitor class'). Though. I'd happily merge
the support for writeable properties. ACPI batteries would
benefit too, i.e. they could export 'alarm' property (see
drivers/acpi/battery.c).

Though, I'd want to apply this patch set as is (i.e. I prefer 
the new behaviour, as it's really more 'user friendly'), and
we could implement configurable option later.

Pavel do you have a strong objection against this patch, or
you can live with it? :-)

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
