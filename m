Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZEZLHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZEZLHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 07:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbZEZLGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:06:54 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33469 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbZEZLGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:06:54 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Tue, 26 May 2009 13:07:22 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, nigel@tuxonice.net,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905260058.54482.rjw@sisk.pl> <20090526091940.GA29867@elf.ucw.cz>
In-Reply-To: <20090526091940.GA29867@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905261307.22664.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. Mai 2009 11:19:40 schrieb Pavel Machek:

Hello,

> For small allocations... I still believe we should free a bit of
> memory for s2ram so that small allocations can be done without
> problems.
> 									Pavel

it is essential that this work. Some subsystems, ie. USB, need to allocate
memory to do IO. For them to work, small allocations must be possible.

Now, is this a real issue? Can most devices really save a device state?
This capability seems to me to be limited to memory mapped IO at best.
USB devices generally don't save and restore state but bring the device
into the state it ought to be in, not the state it was in during resumption.

	Regards
		Oliver

