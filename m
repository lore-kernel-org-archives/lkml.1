Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYGIV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYGIV5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYGIV5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:57:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYGIV5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:57:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: request_firmware vs. resume (was Re: [PATCH] bnx2 - use request_firmware())
Date: Wed, 9 Jul 2008 23:58:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, mchan@broadcom.com, dwmw2@infradead.org,
       bastian@waldi.eu.org, linux-kernel@vger.kernel.org
References: <20080707221950.3dfba435@the-village.bc.nu> <200807092313.55777.rjw@sisk.pl> <20080709212024.GB8517@mit.edu>
In-Reply-To: <20080709212024.GB8517@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092358.32605.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of July 2008, Theodore Tso wrote:
> On Wed, Jul 09, 2008 at 11:13:54PM +0200, Rafael J. Wysocki wrote:
> > > Be careful about request_firmware. Doing it right w.r.t.
> > > suspend/resume is quite tricky: you have to load it from userspace
> > > before kernel starts, so that you can use it during resume...
> > 
> > Rather, you have to cache it in memory before your ->suspend() is invoked.
> 
> Translation: so much for saving "non-swappable kernel memory".
> Unless, of course we add a pre-suspend hook.  (Which doesn't exist
> yet, AFAICT from a quick perusal of Documentation/power/devices.txt.)

No, it doesn't.

You will be able to register a suspend notifier instead, but this requires
one fix which is in the works.

Thanks,
Rafael
