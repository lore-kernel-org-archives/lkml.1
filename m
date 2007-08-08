Return-Path: <linux-kernel-owner+w=401wt.eu-S936082AbXHHP0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936082AbXHHP0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbXHHP0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:26:00 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:32885 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764240AbXHHPZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:25:59 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20070808142059.GF30805@atjola.homenet>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
Content-Type: text/plain; charset=utf-8
Date: Wed, 08 Aug 2007 08:20:45 -0700
Message-Id: <1186586445.22044.52.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 16:20 +0200, Björn Steinbrink wrote:
> On 2007.08.07 17:06:49 -0700, Daniel Walker wrote:
> > 
> > This patch below hangs my system on boot if I set nmi_watchdog=2 . It
> > shows the NMI as stuck then the system hangs .. nmi_watchdog=1 works
> > fine, and the system boots without any watchdog options ..
> > 
> > The machine is an Intel allagash development board, and it has two dual
> > core Pentium-M cpus. I attached the .config I used.
> 
> Should be fixed in commit e82f64e5bb0648a13630d752c35be1e7bd8bab96
> (2.6.23-rc1 IIRC).
> 
> Unfornately it didn't make it into 2.6.22, but the patch should work
> even with 2.6.21 IIRC.

I originally found the problem in 2.6.23-rc2 (actually latest git) so
whatever the problem is still exists ..

Daniel

