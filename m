Return-Path: <linux-kernel-owner+w=401wt.eu-S937178AbYD1T7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937178AbYD1T7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765616AbYD1T7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:59:11 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:45150 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765387AbYD1T7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=RZWGp1rgu3gFNzcNQ9CGpz0Gip5nwhc+IU67ZT++7mLJvGAuYpdAkRw1e4M+UgtGyOuh7amk7lFjxfgAun79CV1qivPl2yomBPoGAohThQihMvFupQ/kU5z11kl6OTlU+ap53XUM8xgS98sDZl7kTqRo06ImkZMdWrTfi8LmeTI=
Date: Mon, 28 Apr 2008 15:58:56 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael@free-electrons.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] pcspkr: fix dependancies
Message-ID: <20080428155811.ZZRA012@mailhub.coreip.homeip.net>
References: <4813476A.7000705@aknet.ru> <200804261918.14711.dtor-oss@comcast.net> <4813BD39.1080105@aknet.ru> <20080427042331.GB29127@anvil.corenet.prv> <481626B6.5040207@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481626B6.5040207@aknet.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 11:34:14PM +0400, Stas Sergeev wrote:
> Hello.
> 
> Dmitry Torokhov wrote:
> > It looks like the change was introduced by commit
> > 67926892ef7a7fbc76de607120d44416019fdf07
> Indeed. But the log message
> http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg36026.html
> doesn't seem to specify the reason
> for the change, so this doesn't
> clarify a thing, unfortunately.
> 
> > I think that we should register devices even if there is no driver in
> > the kernel for it because driver may be compiled at later time or be out
> > of tree. Adding patch author and other people that signed off the patch
> > to CC...
> Since there seem to be no objections,
> would you mind adding the patch to your
> git tree? Or who should that be?

I try to stay within drivers/input boundaries ;) Ingo I think is the
person you need.

-- 
Dmitry
