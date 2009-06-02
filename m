Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZFBNU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZFBNU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbZFBNUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:20:50 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:48035 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbZFBNUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:20:49 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: ttyACM0: 2.6.30-rc7 dies on device disconnect, strange echo (regressions)
Date: Tue, 2 Jun 2009 15:21:23 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-rc7-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090601101421.GA1914@elf.ucw.cz> <200906011434.57083.oliver@neukum.org> <20090602091912.GD15756@elf.ucw.cz>
In-Reply-To: <20090602091912.GD15756@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021521.24248.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 2. Juni 2009 11:19:13 schrieb Pavel Machek:
> > I can replicate neither bug with 2.6.30-rc7. Can you replicate it with
> > anything but openMOKO?
>
> So AT commands echo properly on USB modem or something? Bad :-(.
>
> I'm afraid I do not have another ACM device near me. I guess going
> through cdc-acm.c 's history would be relevant?

The tty layer was changed a lot, so going only through acm's history
is risky. I suggest you do a full bisection.

	Regards
		Oliver

