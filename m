Return-Path: <linux-kernel-owner+w=401wt.eu-S932295AbYD1UMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbYD1UMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934258AbYD1ULx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:11:53 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37629 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbYD1ULw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:11:52 -0400
Date: Mon, 28 Apr 2008 22:12:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stas Sergeev <stsp@aknet.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael@free-electrons.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] pcspkr: fix dependancies
Message-ID: <20080428201225.GB18135@uranus.ravnborg.org>
References: <4813476A.7000705@aknet.ru> <200804261918.14711.dtor-oss@comcast.net> <4813BD39.1080105@aknet.ru> <20080427042331.GB29127@anvil.corenet.prv> <481626B6.5040207@aknet.ru> <20080428155811.ZZRA012@mailhub.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428155811.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 03:58:56PM -0400, Dmitry Torokhov wrote:
> On Mon, Apr 28, 2008 at 11:34:14PM +0400, Stas Sergeev wrote:
> > Hello.
> > 
> > Dmitry Torokhov wrote:
> > > It looks like the change was introduced by commit
> > > 67926892ef7a7fbc76de607120d44416019fdf07
> > Indeed. But the log message
> > http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg36026.html
> > doesn't seem to specify the reason
> > for the change, so this doesn't
> > clarify a thing, unfortunately.
> > 
> > > I think that we should register devices even if there is no driver in
> > > the kernel for it because driver may be compiled at later time or be out
> > > of tree. Adding patch author and other people that signed off the patch
> > > to CC...
> > Since there seem to be no objections,
> > would you mind adding the patch to your
> > git tree? Or who should that be?
> 
> I try to stay within drivers/input boundaries ;) Ingo I think is the
> person you need.
If you google you will find a long thread about this patch.
It is all about saving memory for embedded platforms.
No need to have the driver if there is no speaker on the board.

Ask Michael (author) if you need more info.

	Sam
