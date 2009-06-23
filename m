Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbZFWW7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbZFWW7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbZFWW7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:59:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756168AbZFWW7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:59:20 -0400
Date: Tue, 23 Jun 2009 15:58:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net, s.hauer@pengutronix.de,
       Andrea Paterniani <a.paterniani@swapp-eng.it>
Subject: Re: [PATCH 1/2] remove i.MX SPI driver
Message-Id: <20090623155840.c750b70b.akpm@linux-foundation.org>
In-Reply-To: <1245308072-14392-2-git-send-email-s.hauer@pengutronix.de>
References: <1245308072-14392-1-git-send-email-s.hauer@pengutronix.de>
	<1245308072-14392-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 08:54:31 +0200
Sascha Hauer <s.hauer@pengutronix.de> wrote:

> This driver is in a non working state at the moment and will
> be replaced by a bitbang driver which can also handle the
> newer i.MX variants

hum.  How did it get into a non-working state?

>From the logs, it looks like it was working OK for Andrea Paterniani
when he patched it in April last year.

Ordinarily I'd be asking whether this replacement of one driver with
another is a 100% seamless change.  But I guess that the audience for
SPI drivers are sufficiently technical to be able to handle the odd
Kconfig changes, module parameter changes, module name changes, etc.

But I do think that if there are any such user-visible changes, they
should be described in the changelog.  And I think there are such
changes - the module name at least?


Is it possible and desirable to retain both drivers for a while?  Would
that ease the transition?  It also gives people a fallback driver to
use, if your new driver doesn't work for them.  Just like eepro100.c,
which lived for five years ;)


But it's really hard to make any decisions about this because the
changelog failed to provide any details about the "non working state".

