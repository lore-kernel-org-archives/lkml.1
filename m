Return-Path: <linux-kernel-owner+w=401wt.eu-S2993050AbXEBLKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993050AbXEBLKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993048AbXEBLKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:10:06 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:44733 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993050AbXEBLKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:10:05 -0400
Date: Wed, 2 May 2007 04:10:03 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Markus Rechberger <mrechberger@gmail.com>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] Re: DST/BT878 module customization (.. was:	Critical
 points about ...)
In-Reply-To: <1178071431.11109.62.camel@localhost>
Message-ID: <Pine.LNX.4.58.0705020348080.309@shell2.speakeasy.net>
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com> 
 <1178031333.3958.63.camel@localhost>  <Pine.LNX.4.58.0705011606070.309@shell2.speakeasy.net>
 <1178071431.11109.62.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Mauro Carvalho Chehab wrote:
> Em Ter, 2007-05-01 às 16:16 -0700, Trent Piepho escreveu:
> > On Tue, 1 May 2007, Mauro Carvalho Chehab wrote:
> > > With this configuration, dvb-bt8xx hangs during initialization,
> > > generating an OOPS, if you have a board with DST (modprobe dvb-bt8xx
> > > never returns).
> >
> > Stupid typo in the first patch, a != should have been ==.
> >
> > Fixed:
> > http://linuxtv.org/hg/~tap/dst-new
>
> With the changes, the dst unselection worked.
>
> Those are the logs with dst unselected:
>
> DVB: registering new adapter (bttv0).
> DVB: Unable to find symbol dst_attach()
> frontend_init: Could not find a Twinhan DST.
> dvb-bt8xx: A frontend driver was not found for device 109e/0878 subsystem fbfb/f800

This is the dvb_attach() "not found" message.  You should see this same
message if you leave dst selected and then just delete the dst modules before
loading dvb-bt8xx.

If you turn dvb_attach off, you should see a different "dst support was
disabled" message (and no crash!).

> However, when dst is selected, I got those errors:

When I made this patch I was basing it off a patch I made around 9 months
ago.  I thought since that one was ok, this would be ok too, and in my
hurry to get it done I've clearly put too little effort into checking it,
and I'm sorry to have wasted your time.

I promise, this time it's right!
http://linuxtv.org/hg/~tap/dst-new
