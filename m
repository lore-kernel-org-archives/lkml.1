Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZJ0I0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZJ0I0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbZJ0I0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:26:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34640 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555AbZJ0I0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:26:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [Bug #14355] USB serial regression after 2.6.31.1 with Huawei E169 GSM modem
Date: Tue, 27 Oct 2009 09:28:07 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Ben Efros <ben@pc-doctor.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.xWH.0re5KB@chimera> <1256608490.2076.55.camel@pasglop>
In-Reply-To: <1256608490.2076.55.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910270928.07483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 October 2009, Benjamin Herrenschmidt wrote:
> On Mon, 2009-10-26 at 19:55 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> 
> Well, the E169 works, though there seem to be a few issues remaining:
> 
>  - There are reports that the E220 is still broken (by the same
> regression, just that the patch that fixes the E169 doesn't fix the
> E220, but since I don't have one of these, I'm waiting for users to send
> dumps instead of just complaining :-)
> 
>  - There's a weird glitch where the E169 tend to only work after being
> plugged the -second- time. The first time, the storage device generally
> shows up but not the ttyS's devices for some strange reason. Not sure
> what's up yet. Yanking it and plugging it back works. Could be timing
> related due to the need to load the module.
> 
> None of that happens with 2.6.31.1

Well, I guess it's better to leave the bug open in that case.

Thanks,
Rafael
