Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbYH0QQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbYH0QQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbYH0QQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:16:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4743 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYH0QQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:16:36 -0400
Date: Wed, 27 Aug 2008 17:16:30 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Joe Korty <joe.korty@ccur.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk timestamp post-boot suppression
Message-ID: <20080827161621.GF10834@sirena.org.uk>
References: <20080827151613.GA10325@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827151613.GA10325@tsunami.ccur.com>
X-Cookie: Those who can't write, write manuals.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 11:16:13AM -0400, Joe Korty wrote:

> Its utility after boot is questionable, since 1) the
> timestamp becomes a rather large, unreadable integer,
> as the hours, days and weeks go by, and 2) syslog does
> a proper TOD timestamp anyways on these later messages,
> as they go into /var/log/messages.

It'd be nicer if this were optional - syslog typically only logs at
second resolution and not all systems are going to have logfiles.
