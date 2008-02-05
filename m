Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYBEHY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYBEHY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbYBEHYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:24:47 -0500
Received: from hu-out-0506.google.com ([72.14.214.234]:10318 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbYBEHYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:24:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sJedLLPPTWAI4yqEN3GOSaCrelrGMK5cGFWPvmyr0cXdaAr2JtyNsCfK5hgHn0MBkl7mzoAFAdatXwKD52hOdJ7UOpqYCYKYnC9HHLQnHFuZ9oZFAKNQvo2mJMhCha/mesLOW1c24SGHPKEGPz926lSh2beaTaj4oo/c7AbSEE4=
Message-ID: <b25312890802042324q272324ffo4157f873dd4f44a8@mail.gmail.com>
Date: Tue, 5 Feb 2008 09:24:38 +0200
From: "Rami Rosen" <roszenrami@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-mm1 - Build failure at net/sched/cls_flow.c:598
Cc: "Tilman Schmidt" <tilman@imap.cc>, linux-kernel@vger.kernel.org,
       "Patrick McHardy" <kaber@trash.net>, netdev@vger.kernel.org
In-Reply-To: <20080204152505.62b2b8b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
	 <47A79291.5010204@imap.cc>
	 <20080204152505.62b2b8b5.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  I had sent a patch recently (which is currently pending) which
solves this problem.

see:
http://www.spinics.net/lists/netdev/msg54455.html


Regards,
Rami Rosen


On Feb 5, 2008 1:25 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 04 Feb 2008 23:32:49 +0100
> Tilman Schmidt <tilman@imap.cc> wrote:
>
> > My attempt to build this failed with:
> >
> >    CC [M]  net/sched/cls_flow.o
> > net/sched/cls_flow.c: In function ___flow_dump___:
> > net/sched/cls_flow.c:598: error: ___struct tcf_ematch_tree___ has no member named ___hdr___
> >
> > Config attached.
>
> Thanks.  hm.
>
>         #else /* CONFIG_NET_EMATCH */
>
>         struct tcf_ematch_tree
>         {
>         };
>
> methinks Patrick has a CONFIG_NET_EMATCH=n problem?
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
