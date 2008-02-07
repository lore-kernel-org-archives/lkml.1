Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbYBGKcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbYBGKcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbYBGKbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:31:44 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:45977 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755291AbYBGKbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:31:43 -0500
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: Pardus / KDE
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 2/2] ASLR: add possibility for more fine-grained tweaking
Date: Thu, 7 Feb 2008 12:31:47 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz> <20080206134959.GA25689@elte.hu> <Pine.LNX.4.64.0802071120110.11914@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0802071120110.11914@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802071231.47614.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Thursday 07 February 2008 around 12:23:50 Geert Uytterhoeven wrote:
> On Wed, 6 Feb 2008, Ingo Molnar wrote:
> > @@ -541,6 +541,18 @@ config ELF_CORE
> >       help
> >         Enable support for generating core dumps. Disabling saves about
> > 4k. 
> > +config COMPAT_BRK
> > +     bool "Disable heap randomization"
> > +     default y
> > +     help
> > +       Randomizing heap placement makes heap exploits harder, but it
> > +       also breaks ancient binaries (including anything libc5 based).
> > +       This option changes the bootup default to heap randomization
> > +       disabled, and can be overriden runtime by setting
> > +       /proc/sys/kernel/randomize_va_space to 2.
> > +
> > +       On non-ancient distros (post-2000 ones) Y is usually a safe
> > choice.
>
> Somehow my belly feeling tells me something is wrong with this
> description...
>
> Ah, a negative option (Y -> disable).  So Y is always safe.
>
> `non-ancient distros' really means `recent distros', and if you have one,
> then _N_ should be a safe choice, too?

This indeed looks wrong. The default should be N and the text should say "On 
recent distros (post-2000 ones) N is usually a safe choice".

Regards,
ismail

-- 
Never learn by your mistakes, if you do you may never dare to try again.
