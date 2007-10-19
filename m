Return-Path: <linux-kernel-owner+w=401wt.eu-S935611AbXJSH41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935611AbXJSH41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935290AbXJSHzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:55:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45520 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935257AbXJSHzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:55:50 -0400
Date: Fri, 19 Oct 2007 09:55:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH -mm] Freezer: Do not allow freezing processes to
	clear TIF_SIGPENDING
Message-ID: <20071019075555.GA9756@elf.ucw.cz>
References: <200710190022.36145.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710190022.36145.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-10-19 00:22:35, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Do not allow processes to clear their TIF_SIGPENDING if TIF_FREEZE is set,
> to prevent them from racing with the freezer (like mysqld does, for example).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK. We want this in 2.6.24.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
