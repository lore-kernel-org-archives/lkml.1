Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbXCNRXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbXCNRXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXCNRXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:23:13 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:32835 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752561AbXCNRXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:23:12 -0400
Date: Wed, 14 Mar 2007 18:23:10 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linuxppc-dev@ozlabs.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] fix ps3fb glue allowing a modular build
In-Reply-To: <20070314170720.GL4095@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.62.0703141822240.28462@pademelon.sonytel.be>
References: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk>
 <Pine.LNX.4.62.0703141040030.28462@pademelon.sonytel.be>
 <20070314160258.GK4095@ftp.linux.org.uk> <Pine.LNX.4.62.0703141715570.28462@pademelon.sonytel.be>
 <20070314170720.GL4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Al Viro wrote:
> On Wed, Mar 14, 2007 at 05:17:45PM +0100, Geert Uytterhoeven wrote:
> > On Wed, 14 Mar 2007, Al Viro wrote:
> > > On Wed, Mar 14, 2007 at 10:50:16AM +0100, Geert Uytterhoeven wrote:
> > > > On Wed, 14 Mar 2007, Al Viro wrote:
> > > > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > > 
> > > > NAK
> > > 
> > > Lovely...  Consider that one withdrawn, please.  FWIW, if we leave it bool
> > > (and flip_ctl mess alone would make a good reason for that) we probably want
> > > to have it depend on FB=y
> > 
> > What's the advantage of making FB_PS3 depend on FB=y vs. plain FB?
> > In both cases it can be enabled if FB=y only, right? Or am I missing something?
> 
> Nope.  How can kconfig distinguish that from a boolean option in modular
> driver?  bool *can* depend on tristate and be selected when tristate is
> set to m.

Sorry, you're right. I tried it before sending the previous mail, but
apparently I made a mistake. I tried again, and now it indeed allows me to
select FB_PS3.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
