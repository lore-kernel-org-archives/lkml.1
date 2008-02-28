Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbYB1PMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbYB1PMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbYB1PMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:12:24 -0500
Received: from hu-out-0506.google.com ([72.14.214.238]:42815 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbYB1PMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:12:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BU8n+LVe2e/QiQPYjFktl4KhursVT0TNl3IpwW3UbowbwJ47o+kaeHR1/mVqjvSSX7KWz3IEYvMEJ19kVO9+nkBDFKE2YxCkt7ObGTe7Et+FMUu7rfzxIZxtMlP9YDGXR1QkZiLPcWORI4l2y/pRnU5Dqaj68QM9s0jRW6tHyzM=
Message-ID: <517f3f820802280712o3d756b4fq46461b226515e1f2@mail.gmail.com>
Date: Thu, 28 Feb 2008 16:12:21 +0100
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] proc: Add RLIMIT_RTTIME to /proc/<pid>/limits
Cc: "Eugene Teo" <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       "Neil Horman" <nhorman@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>,
       mtk.manpages@gmail.com
In-Reply-To: <1202483445.6292.1.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080208145950.GA3910@kernel.sg> <1202483445.6292.1.camel@lappy>
X-Google-Sender-Auth: 8f4bca003fad159f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Could you please provide some text describing RLIMIT_RTTIMEfor the
getrlimit.2 man page.

Cheers,

Michael

On Fri, Feb 8, 2008 at 4:10 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Fri, 2008-02-08 at 22:59 +0800, Eugene Teo wrote:
> > RLIMIT_RTTIME was introduced to allow the user to set a runtime timeout on
> > real-time tasks: http://lkml.org/lkml/2007/12/18/218. This patch updates
> > /proc/<pid>/limits with the new rlimit.
>
> Ah, didn't know about that file, thanks!
>
> > Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
>
> > ---
> >  fs/proc/base.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index c59852b..dcf7be8 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -412,6 +412,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
> >       [RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
> >       [RLIMIT_NICE] = {"Max nice priority", NULL},
> >       [RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
> > +     [RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
> >  };
> >
> >  /* Display limits for a process */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
I'll likely only see replies if they are CCed to mtk.manpages at gmail dot com
