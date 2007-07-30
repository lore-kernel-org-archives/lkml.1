Return-Path: <linux-kernel-owner+w=401wt.eu-S938900AbXG3HGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938900AbXG3HGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 03:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937845AbXG3HGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 03:06:06 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:55479 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934212AbXG3HGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 03:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MAOhf8avraMLlCQAxxUkzgQxGrN3HVd5ltfK15G8F+9jruWCp0ytyQlDHaphID4868P+fXf6B2pWp30rO1S2baWvg08DwW6p0NX9Gy+HA8dclNJCswW46oURcUzIdVcqQVZhB4Syl1eTepfsbzxCMwklBCGadJ2P0wnyfWhOrao=
Message-ID: <a12e280d0707300006l52a695bcy9912ee2689d6f636@mail.gmail.com>
Date: Mon, 30 Jul 2007 17:06:02 +1000
From: "George Sescher" <gesacs@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Linus 2.6.23-rc1
Cc: "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "CK Mailinglist" <ck@vds.kolivas.org>
In-Reply-To: <20070730064423.GA30505@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185588279.1654.1.camel@localhost> <20070729150436.GA6598@elte.hu>
	 <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com>
	 <20070730064423.GA30505@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > On 30/07/07, Ingo Molnar <mingo@elte.hu> wrote:
> > > i'd encourage you to do it - in fact i already tried to prod Peter
> > > Williams into doing exactly that ;) The more reality checks a
> > > scheduler has, the better. [ Btw., after the obvious initial merging
> > > trouble it should be much easier to keep SD maintained against
> > > future upstream kernels due to the policy modularity that CFS
> > > introduces. (and which policy-modularity should also help reduce the
> > > size and complexity of the SD patch.) ]

> * George Sescher <gesacs@gmail.com> wrote:
> > <chuckle>
> >
> > You're advocating plugsched now?

On 30/07/07, Ingo Molnar <mingo@elte.hu> wrote:
> hm, the way you posited this question implies that you see an
> inconsistency in my position or that it surprised you - i cannot explain
> the '<chuckle>' in any other way :) Which bit do you see as inconsistent
> and/or which bit surprised you and why?

The idea is not good enough for mainline and has no place in mainline
yet you say it's very important to maintain it... but out of mainline.
Place the responsibility of keeping mainline's performance in check
"reality check as you called it" on to someone who is forced to
develop out of mainline? I have zero interest one way or the other
myself, but how can one not chuckle?

Again I have no interest either way but if this is that important a
reality check that it needs maintaining it should be oh I don't know,
an -mm only feature or something?

Please don't jump down my throat, your position just needs clarifying.  :-|
