Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbYBYWfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbYBYWfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbYBYWet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:34:49 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53284 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757402AbYBYWes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:34:48 -0500
Date: Mon, 25 Feb 2008 23:24:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-ide@vger.kernel.org
Subject: Re: new regression in 2.6.25-rc3: can't resume from suspend to
	ram, ata1 errors
Message-ID: <20080225222400.GA4093@elf.ucw.cz>
References: <8f53421d0802251257o75d2975dldcfb99a2dc5e3539@mail.gmail.com> <47C32D48.7060909@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C32D48.7060909@garzik.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-02-25 16:04:08, Jeff Garzik wrote:
> Michael S. Tsirkin wrote:
>> git bisect points at this commit:
>> commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2.
>> power_state: get rid of write-only variable in SATA
>
>
> Hello Pavel --
>
> It looks like this not a write-only variable after all...

Yep, right and sorry.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
