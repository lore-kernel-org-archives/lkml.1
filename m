Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZBICeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZBICeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 21:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZBICeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 21:34:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:41085 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbZBICeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 21:34:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=owkzXwzVlfWff4SDBBeZFx4tE++D7WTGrSLM1rR1B3zjd0gR3Er4loE4JqzUrUpZzo
         LigBMzl5UoJ9LmpKFGoARW3vOXvti/jsoMHA0Xyo3UM58yZ1xrmKpZUGRRn3nxQglHna
         cDwkoA0GIF0nUfndxgX7MeA5NAn4lXUFb3fW4=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.10.0902081504380.18839@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902081504380.18839@alien.or.mcafeemobile.com>
Date: Mon, 9 Feb 2009 15:34:11 +1300
Message-ID: <cfd18e0f0902081834l55142925i1f2f068e4aa9b145@mail.gmail.com>
Subject: Re: [patch 1/2] timerfd add flags check
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 12:23 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> Like Michael requested, this patch adds a missing check for valid flags in
> timerfd_settime(), and make it return EINVAL in case some extra bits are
> set. If this is or not a -stable thing, it Greg decision.
> Should be queued by Andrew for .30, unless -stable and Linus decide to
> get it before, like Michael suggested.

When these two patches are applied against .29-rc3:

$ make
[...]
  CC      fs/timerfd.o
fs/timerfd.c: In function 'sys_timerfd_create':
fs/timerfd.c:190: error: implicit declaration of function 'invalid_clockid'
make[1]: *** [fs/timerfd.o] Error 1
make: *** [fs] Error 2


Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
