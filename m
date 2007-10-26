Return-Path: <linux-kernel-owner+w=401wt.eu-S1763273AbXJZPX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763273AbXJZPX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbXJZPXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:23:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35039 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbXJZPXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:23:08 -0400
Date: Fri, 26 Oct 2007 17:22:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] raid6: generate raid6tables.c with proper style
Message-ID: <20071026152257.GB26619@elte.hu>
References: <20071026081752.GA1232@elte.hu> <1193397991.7078.5.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1193397991.7078.5.camel@odie.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Holm Thøgersen <odie@cs.aau.dk> wrote:

> fre, 26 10 2007 kl. 10:17 +0200, skrev Ingo Molnar:
> > Subject: raid6: generate raid6tables.c with proper style
> > From: Ingo Molnar <mingo@elte.hu>
> 
> [snip]
> 
> > Index: linux/drivers/md/mktables.c
> > ===================================================================
> > --- linux.orig/drivers/md/mktables.c
> > +++ linux/drivers/md/mktables.c
> > @@ -69,7 +69,9 @@ int main(int argc, char *argv[])
> >      for ( j = 0 ; j < 256 ; j += 8 ) {
> >        printf("\t\t");
> >        for ( k = 0 ; k < 8 ; k++ ) {
> > -	printf("0x%02x, ", gfmul(i,j+k));
> > +        if (k)
> > +	  printf(" ");
> > +	printf("0x%02x,", gfmul(i,j+k));
> 
> What happened with the coding style here?

i adopted to the existing (broken) one. Yes, mktables.c could need a 
good cleanup too.

	Ingo
