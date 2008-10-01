Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbYJAHYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbYJAHYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYJAHYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:24:34 -0400
Received: from smtp3.ono.com ([62.42.230.176]:39847 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750785AbYJAHYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:24:34 -0400
Date: Wed, 1 Oct 2008 09:24:28 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: change MTRR_SANITIZER to def_bool y
Message-ID: <20081001092428.21e1b7df@werewolf.home>
In-Reply-To: <86802c440809302346h28dfb83fif1436e63fd819b7a@mail.gmail.com>
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
	<1222817380-29481-3-git-send-email-yhlu.kernel@gmail.com>
	<20081001063632.GA30756@elte.hu>
	<86802c440809302346h28dfb83fif1436e63fd819b7a@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0cvs140 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 23:46:54 -0700, "Yinghai Lu" <yinghai@kernel.org> wrote:

> On Tue, Sep 30, 2008 at 11:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >>
> >> ---
> >>  arch/x86/Kconfig |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > applied the patch below to tip/x86/mtrr, thanks Yinghai!
> >
> > (i'll wait for v2 of the mtrr parameter documentation patches.)
> 
> mtrr-cleanup-debug, mtrr-clearnup, nomtrr-cleanup  - v2 the 1/3 and
> 2/3 in series...
> or
> mtrr_cleanup_debug, mtrr_clearnup, nomtrr_cleanup -V?
> or
> mtrrcleanup_debug, mtrrclearnup, nomtrrcleanup -v1
> 
> which one should we use ?
> 

My vote ;)

mtrr-cleanup (mtrr-sanitize ?)
mtrr-nocleanup (probably better mtrr-asis or mtrr-default ?)
mtrr-debug

And you could get all parameters with dashes instead of underlines:

mtrr_chunk_size   -> mtrr-chunk-size
mtrr_gran_size    -> mtrr-gran-size
mtrr_spare_reg_nr -> mtrr-spare-regs (mtrr-spares ?)
disable_mtrr_trim -> mtrr-notrim (mtrr-trim needed for symmetry ?)

All begin with mtrr- and alpha ordering groups them together :).

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
