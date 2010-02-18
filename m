Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab0BRMfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:35:06 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34461 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab0BRMfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:35:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Cq/oqwO1Cw7ZqdUjy+YTxR/h+OxgU/TiJHWQXn55eZKQhlRZCdCdqeE0bheDcoTZ+6
         ww5AfHBLHpZZlJCTwS4SIQCM06mfA4/ZaaFMyw4qIVO7POh2ON0mgknS2PEZ0338GgJy
         Xepfo5gb6KtvSava+mn0o2kgpqt+GuidXbmYc=
Date: Thu, 18 Feb 2010 13:34:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
Message-ID: <20100218123453.GA5136@nowhere>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com> <1266491616-6270-3-git-send-regression-fweisbec@gmail.com> <8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com> <20100218120944.GA2406@osiris.boeblingen.de.ibm.com> <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 07:12:08AM -0500, Mike Frysinger wrote:
> On Thu, Feb 18, 2010 at 07:09, Heiko Carstens wrote:
> > On Thu, Feb 18, 2010 at 06:18:20AM -0500, Mike Frysinger wrote:
> >> On Thu, Feb 18, 2010 at 06:13, Frederic Weisbecker wrote:
> >> > --- a/arch/Kconfig
> >> > +++ b/arch/Kconfig
> >> > @@ -121,6 +121,9 @@ config HAVE_DMA_ATTRS
> >> >  config USE_GENERIC_SMP_HELPERS
> >> >        bool
> >> >
> >> > +config HAVE_REGS_AND_STACK_ACCESS_API
> >> > +       bool
> >> > +
> >>
> >> could you add an appropriate help/comment so arch peeps know what
> >> needs to be implemented before they can select this
> >
> > That's why I added the commit ID for the regs and stack access api
> > to the changelog. imho that should be sufficient.
> > Besides that the next commit would implement it for s390 as a
> > blueprint for others. That is... for those that missed the initial
> > x86 implementation.
> 
> people shouldnt have to dive into the changelog to try and divine
> documentation.  it's hardly standard, so people fall on it in a
> pima-last-resort kind of way.  being explicit in the file up front by
> writing real documentation says other people a lot more time.
> -mike


Yeah, would be nice to have a comment above the config definition
to explain what it implies.

Heiko, mind sending a delta patch for that?

Thanks.

