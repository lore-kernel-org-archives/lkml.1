Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbYCDNuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbYCDNuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYCDNuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:50:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbYCDNui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:50:38 -0500
Date: Tue, 4 Mar 2008 10:50:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manu Abraham <manu@linuxtv.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "v4l-dvb-maintainer@linuxtv.org" <v4l-dvb-maintainer@linuxtv.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace remaining
 __FUNCTION__ occurences
Message-ID: <20080304105024.0873ad72@gaivota>
In-Reply-To: <47CD256B.2070305@linuxtv.org>
References: <1204588990.22933.28.camel@brick>
	<37219a840803031928l79395c78ka64192f4a9f61744@mail.gmail.com>
	<47CCDB5F.1040007@gmail.com>
	<47CCEE63.80103@linuxtv.org>
	<47CD256B.2070305@linuxtv.org>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2008 14:33:15 +0400
Manu Abraham <manu@linuxtv.org> wrote:

> Michael Krufky wrote:
> > Manu Abraham wrote:
> >> Michael Krufky wrote:
> >>> On Mon, Mar 3, 2008 at 7:03 PM, Harvey Harrison
> >>> <harvey.harrison@gmail.com> wrote:
> >>>> __FUNCTION__ is gcc-specific, use __func__
> >>>>
> >>>>  Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> >>>>   162 files changed, 892 insertions(+), 892 deletions(-)
> >>>
> >>> If we apply this, can it be broken down into several smaller patches?
> >>> I am in the midst of a large overhaul of the tuning subsystem, and if
> >>> this all gets applied at once, it will wreck havoc on my pending
> >>> changesets.
> >> Please make sure your changes don't conflict with the multiproto tree
> >> changes.
> >>
> >> Regards,
> >> Manu
> > Manu,
> > 
> > Does that mean that you plan to merge multiproto soon?  If that's the
> 
> I hope to do so, unless there aren't any significant issues. The 
> multiproto tree is at
> http://jusst.de/hg/multiproto.
> 
> (There's hell a lot of reviewing and testing going on by the testers on 
> the linux-dvb
> ML, but you might additionally like to check whether any of your devices 
> have any
> side effects)

Maybe the better would be if we merge from multiproto. Then, Harvey can safely
generate the __FUNCTION__ changesets.

Manu,

Can I merge it?

Cheers,
Mauro
