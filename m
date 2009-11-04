Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbZKDVqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbZKDVqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932937AbZKDVqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:46:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46501 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbZKDVqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:46:44 -0500
Date: Wed, 4 Nov 2009 22:46:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] power: pcf50633: properly reenable charging when
 the supply conditions change
Message-ID: <20091104214622.GA27325@elf.ucw.cz>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
 <1257369899-325-2-git-send-email-fercerpav@gmail.com>
 <1257369899-325-3-git-send-email-fercerpav@gmail.com>
 <1257369899-325-4-git-send-email-fercerpav@gmail.com>
 <1257369899-325-5-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257369899-325-5-git-send-email-fercerpav@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-11-05 00:24:58, Paul Fertser wrote:
> If chgmod == BATFULL, setting chgena has no effect. Datasheet says we
> need to set resume instead but when autoresume is used resume doesn't
> work. Clear and set chgena instead.
> 
> This enables a user to force charging by re-plugging USB even when the
> charger entered Battery Full mode, might be handy before a long
> trip.

And is against manufacturer recommendation and will unneccessary
shorted life of battery with frequent plugs/unplugs. Is it good idea?

If you want to "top-up" the battery, perhaps that should be on
explicit request, like something in /sys?
								Pavel




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
