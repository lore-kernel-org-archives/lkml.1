Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab0BCQbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:31:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60122 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab0BCQbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:31:08 -0500
X-Authority-Analysis: v=1.0 c=1 a=KJe5iWfhaysA:10 a=7U3hwN5JcxgA:10 a=VnNF1IyMAAAA:8 a=dyr_FxWbAgKZ4Ht3QQkA:9 a=Dkapp0fBIY4Hm9dX-f_h4-iQDMoA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/3] trace-cmd: fix printf compile warnings
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@redhat.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <520f0cf11002030807t48678b82ye56624840e6f9ce3@mail.gmail.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
	 <1265043026-24987-3-git-send-email-dvhltc@us.ibm.com>
	 <520f0cf11002030807t48678b82ye56624840e6f9ce3@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Feb 2010 11:31:05 -0500
Message-ID: <1265214665.24386.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 17:07 +0100, John Kacur wrote:
> On Mon, Feb 1, 2010 at 5:50 PM, Darren Hart <dvhltc@us.ibm.com> wrote:
> > Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> > ---
> >  trace-read.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/trace-read.c b/trace-read.c
> > index a04c85b..5befaba 100644
> > --- a/trace-read.c
> > +++ b/trace-read.c
> > @@ -216,7 +216,7 @@ static void read_rest(void)
> >                r = read(input_fd, buf, BUFSIZ);
> >                if (r > 0) {
> >                        buf[r] = 0;
> > -                       printf(buf);
> > +                       printf("%s", buf);
> >                }
> >        } while (r > 0);
> >  }
> > --
> > 1.6.3.3
> >
> 
> Oh! Obviously correct, thanks Darren.

Of the three patches, I think this is the only one that is correct ;-)


-- Steve



