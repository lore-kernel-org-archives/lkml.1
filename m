Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZBKKrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZBKKrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZBKKri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:47:38 -0500
Received: from harmaja.edelkey.net ([213.138.147.141]:52186 "EHLO
	harmaja.edelkey.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZBKKrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:47:37 -0500
Subject: Re: [PATCH 0/2] TWL: USB: Start using twl4030/5030 regulator driver
From: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
To: David Brownell <david-b@pacbell.net>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
       jouni.hogander@nokia.com, broonie@sirena.org.uk
In-Reply-To: <200902102323.30395.david-b@pacbell.net>
References: <> <1234336002-26372-1-git-send-email-kalle.jokiniemi@digia.com>
	 <200902102323.30395.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Digia / Pori
Date: Wed, 11 Feb 2009 12:47:15 +0200
Message-Id: <1234349235.17391.104.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 11 Feb 2009 10:47:17.0048 (UTC) FILETIME=[1B463B80:01C98C36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 23:23 -0800, David Brownell wrote:
> On Tuesday 10 February 2009, Kalle Jokiniemi wrote:
> > These couple of patches enable dynamic swithcing of the
> > regulators used by twl4030 usb tranceiver.
> > 
> > This set replaces the single patch "USB: disable twl4030
> > USB regulators when cable unplugged" sent previously.
> > The change to previous version is that possible errors
> > in regulator_get are now handled and the twl4030 usb
> > driver requires TWL_REGULATOR support to be compiled.
> 
> It'd make more sense to me as a single patch ... :)

OK, I'll put them together.

> 
> And also, instead of *continuing* after the regulators
> can't be acquired, it's better to abort.  It's not
> going to be able to do anything ... so don't finish
> probing, and don't register this "dead" transceiver.

Makes sense. I'll fix that.

-Kalle

> 
> - Dave
