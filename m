Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbXDWXGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbXDWXGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbXDWXGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:06:41 -0400
Received: from sf01.pol.net ([63.240.86.10]:20026 "EHLO sf01.pol.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbXDWXGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:06:40 -0400
Message-ID: <8245.10.250.10.1.1177369597.squirrel@www01.pol.sec1.webmd.com>
Date: Tue, 24 Apr 2007 07:06:37 +0800 (PHT)
Subject: Re: Prevent softlockup triggering in nvidiafb
From: "Antonino A. Daplas" <adaplas@pol.net>
To: <davej@redhat.com>
In-Reply-To: <20070423161848.GA27649@redhat.com>
References: <20070423151053.GA5653@redhat.com>
        <20070423165505.4aecd186@the-village.bc.nu>
        <20070423161848.GA27649@redhat.com>
X-Priority: 3
Importance: Normal
X-MSMail-Priority: Normal
Cc: <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
       <adaplas@pol.net>
Reply-To: adaplas@pol.net
X-Mailer: SquirrelMail (version 1.2.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 23, 2007 at 04:55:05PM +0100, Alan Cox wrote:
>  > On Mon, 23 Apr 2007 11:36:30 -0400
>  > Dave Jones <davej@redhat.com> wrote:
>  >
>  > > If the chip locks up, we get into a long polling loop,
>  > > where the softlockup detector kicks in.
>  > > See https://bugzilla.redhat.com/bugzilla/attachment.cgi?id=151878
> for an example.
>  >
>  > Surely in this situation the softlockup report and trap out is
> precisely what should be occurring.
>
> We can't do anything useful with the trace.  It already prints out info
> that the hardware locked up.

And when nvidiafb detects a lockup, it will go to safe mode. Better than
rebooting, I think.

Tony



