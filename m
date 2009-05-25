Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZEYNWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZEYNWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZEYNWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:22:01 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33149 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZEYNWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:22:01 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Mon, 25 May 2009 15:22:26 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Nigel Cunningham <nigel@tuxonice.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <1243243666.16743.64.camel@nigel-laptop> <20090525123228.GA13446@elf.ucw.cz>
In-Reply-To: <20090525123228.GA13446@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905251522.26852.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 25. Mai 2009 14:32:28 schrieb Pavel Machek:
> > I'm going to try to. Unfortunately, they'll require what's basically a
> > group-up redesign of the basic algorithm, because to get maximum
> > reliability, you need to carefully account for the amount of storage
> > you're going to need and the amount of memory you have available, and
> > 'prepare' the image prior to doing the atomic copy.
>
> I don't quite get it; why is that needed?
>
> If there's not enough swap available, swsusp should freeze, realize
> there's no swap, unfreeze and continue. I do not see reliability
> problem there.

The software suspend may be a part of your response to an imminent
power failure (UPS near empty). The number of retries available is possibly
limited.
I'd feel safer if hibernation by default wrote to a dedicated partition,
especially as modern practice is to make swap space smaller than RAM.

	Regards
		Oliver

