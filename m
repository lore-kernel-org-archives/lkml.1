Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbYBYMcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbYBYMcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 07:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYBYMca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 07:32:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58315 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbYBYMc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 07:32:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Mon, 25 Feb 2008 13:31:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, David Brownell <david-b@pacbell.net>
References: <Pine.LNX.4.44L0.0802242119500.31164-100000@netrider.rowland.org> <200802251241.26216.rjw@sisk.pl> <c4e36d110802250402q7312a488idf752e07db7504e8@mail.gmail.com>
In-Reply-To: <c4e36d110802250402q7312a488idf752e07db7504e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251331.01085.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of February 2008, Zdenek Kabelac wrote:
> Hi

Hi,

[CCs restored, added CC to Dave]

> I'm finally going to test some kernel - because I'd been trying it
> against the HEAD - but unfortunately  it looks like there is something
> seriously broken with -rc3 and sata merge - anyway - I'm going to make
> a test with this head commit 85b80ebfa4384b8ea30cc1af9617db30319a9ccd
> which should be the last one before merge of SATA.
> 
> So I'm going to check this tree with you patch:
> pm-remove-locking-from-core.patch

If that's the one from http://marc.info/?l=linux-acpi&m=120389632114090&w=2 ,
please do it.

> ---
>  drivers/base/core.c       |    8 ---
>  drivers/base/power/main.c |   97 +++-------------------------------------------
>  drivers/usb/core/usb.c    |    2
>  3 files changed, 8 insertions(+), 99 deletions(-)
> 
> Do you wan to test also the other patch ?

Yes.  Please also test the patch that Alan asked you to test here:
http://lkml.org/lkml/2008/2/23/402
It's experimantal, but it is important to us to know if you see the symptoms
(and which ones if you do) with this patch applied.

Thanks,
Rafael
