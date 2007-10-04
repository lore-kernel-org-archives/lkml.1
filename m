Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbXJDTSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbXJDTSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXJDTSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:18:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:17612 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbXJDTSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=d7Z6uxMZO856JcEKBzaO5V4FHHa0HhZI1c0sxcJTkaxPoizXNuRropIYqOlmFYCkFTr7PARZ6IR0FQFW4IJMr8bwYe07P5ZJtocbs0BBDLCR8lt7vWtNr9b79dfqgj2H+GanMM+UL47LVk7fY4akaSIjrOCeOnaE/sZjfmwOYJ4=
Date: Thu, 4 Oct 2007 21:19:21 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: Willy Tarreau <w@1wt.eu>, LKML <linux-kernel@vger.kernel.org>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: Decreasing stime running confuses top (was: top displaying
	9999% CPU usage)
Message-ID: <20071004191921.GA24011@dreamland.darkstar.lan>
References: <200710031433.34504.elendil@planet.nl> <200710032127.42147.elendil@planet.nl> <20071003202446.GQ10199@1wt.eu> <200710040132.45062.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710040132.45062.elendil@planet.nl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Thu, Oct 04, 2007 at 01:32:44AM +0200, Frans Pop ha scritto: 
> On Wednesday 03 October 2007, you wrote:
> > On Wed, Oct 03, 2007 at 09:27:41PM +0200, Frans Pop wrote:
> > > On Wednesday 03 October 2007, you wrote:
> > > > On Wed, 3 Oct 2007, Ilpo Järvinen wrote:
> > > > > On Wed, 3 Oct 2007, Frans Pop wrote:
> > > > > > The only change is in 2 consecutive columns: "2911 502" -> "2912
> > > > > > 500". Is processor usage calculated from those? Can someone
> > > > > > explain how?
> > > > >
> > > > > The latter seems to be utime ...decreasing. No wonder if
> > > > > arithmetics will give strange results (probably top is using
> > > > > unsigned delta?)...
> > > >
> > > > Hmm, minor miscounting from my side, stime seems more appropriate...
> > >
> > > So, is it normal that stime decreases sometimes or a kernel bug?
> > > /me expects the last...
> >
> > Let me guess... Dual core AMD64 ?
> 
> Nope: Intel(R) Pentium(R) D CPU 3.20GHz

I just notice the same thing here, with a Core2 Duo (which is supposed
to have synced TSCs) and working HPET.

> The following may well be relevant.
> With 2.6.22 and early 2.6.23-rc kernels (rc3-rc6) I often had this in my
> kernel log (see http://lkml.org/lkml/2007/9/16/45):
>    checking TSC synchronization [CPU#0 -> CPU#1]:
>    Measured 248 cycles TSC warp between CPUs, turning off TSC clock.
>    Marking TSC unstable due to check_tsc_sync_source failed

I don't see this though, TSCs are always syncronized between the 2
cores.

Luca
-- 
Ligabue canta: "Tutti vogliono viaggiare in primaaaa..."
Io ci ho provato e dopo un chilometro ho fuso il motore e bruciato
la frizione...
