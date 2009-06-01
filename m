Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZFALnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZFALnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 07:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbZFALns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 07:43:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46151 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbZFALns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:43:48 -0400
Date: Mon, 1 Jun 2009 13:43:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Fix floppy hibernation
Message-ID: <20090601114342.GA2454@elf.ucw.cz>
References: <200905301804.26762.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905301804.26762.linux@rainbow-software.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-05-30 18:04:25, Ondrej Zary wrote:
> Hello,
> floppy driver was always missing hibernation support. After resume, floppy did
> not work (until a couple of disk reinserts and retries), producing errors like
> this:
> end_request: I/O error, dev fd0, sector 0
> 
> Ingo Molnar tried to fix it in 2006: http://lkml.org/lkml/2006/11/12/92
> 
> 
> 
> 
> Based on Ingo Molnar's patch from 2006, this makes the floppy work after
> resume from hibernation, at least on my machine.
> 
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Acked-by: Pavel Machek <pavel@ucw.cz>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
