Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYLBQO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYLBQO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYLBQOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:14:48 -0500
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:9665
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979AbYLBQOr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:14:47 -0500
X-Trace: 201576043/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6/None/alistair@devzero.co.uk
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-MUA: KMail/1.10.3 (Linux/2.6.28-rc6-damocles; KDE/4.1.3; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEANPtNEnDlSwG/2dsb2JhbACBbdEXgn8
X-IronPort-AV: E=Sophos;i="4.33,702,1220223600"; 
   d="scan'208";a="201576043"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Alejandro Riveira =?iso-8859-1?q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Subject: Re: Linux 2.6.28-rc7
Date: Tue, 2 Dec 2008 16:14:44 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-damocles; KDE/4.1.3; x86_64; ; )
Cc: pazke <pazke@ports.donpac.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <200812021520.25856.alistair@devzero.co.uk> <20081202165047.3d09bf43@varda>
In-Reply-To: <20081202165047.3d09bf43@varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812021614.44594.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2008 15:50:47 Alejandro Riveira Fernández wrote:
> El Tue, 2 Dec 2008 15:20:25 +0000
>
> Alistair John Strachan <alistair@devzero.co.uk> escribió:
> > (Maybe things have changed over the years, but my understanding was that
> > for the majority of Xorg drivers, mode setting was still done by the Xorg
> > driver, not the kernel, and the X server is responsible for restoring the
> > VT correctly, not the kernel's framebuffer driver. So this may possibly
> > not be a kernel bug at all.)
>
>  Given that this is easily reproducible i may try to biect rc6 <--> rc7...
> it may take a few days though

Definitely a good course of action. Hardly anything in rc7, and if the bug 
really is that localised that's good news.

The only frame-buffer commit in rc7 was bca404afdc5206c3bb but this looks 
unrelated.

-- 
Cheers,
Alistair.
