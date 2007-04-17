Return-Path: <linux-kernel-owner+w=401wt.eu-S1030669AbXDQPeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030669AbXDQPeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030657AbXDQPeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:34:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:25809 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030608AbXDQPeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:34:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SVj+s4lZU3cUGtF2cpChmeq8gPSSy6idQ8sLArf7t0kbWDSDhOTMp19Nx89J3n7YUxlAT7ewz6uGlqewqRXqnL3RgJ7pkboXOiOZxNwrDAHyCBD1sDjk7zbCZpB87o0/SPTAA6icXOr3PgH6orxpf0VPPiOQHWd3FO9Oq1JL8mA=
Message-ID: <38b2ab8a0704170834i1856886nafeeec692f49fea0@mail.gmail.com>
Date: Tue, 17 Apr 2007 17:34:12 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <20070417150859.GA9512@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070417130431.GA8685@2ka.mipt.ru>
	 <E1HdnwX-0005U1-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704170701p69fd547dwe3e2523ba5798b55@mail.gmail.com>
	 <20070417150859.GA9512@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> On Tue, Apr 17, 2007 at 04:01:51PM +0200, Francis Moreau (francis.moro@gmail.com) wrote:
> > On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > >Yep.  We don't need such a flag anyway.  All we need is a way to tweak
> > >the priority and Bob's your uncle.
> > >
> >
> > Could you elaborate please, I don't see how you prevent others users
> > to use this module with priority.
> >
> > Priority is a stuff that tells you which aes implementation to use but
> > it does not prevent an implementation to be used several times...
>
> Preventing anyone from using the module is incorrect.
> How will you handle the case when you have only one algo registered and
> it will be exclusively used by ecryptfs?
>

As I tried to explain, in that case the admin must load the module
without the exclusive flag.

> Herbert proposes to register _second_ algo (say aes-generic(prio_100)
> and aes_for_ecryptfs(prio_1)) with lower prio, so generic access will
> never try to catch aes_for_ecryptfs, but your code still can access it
> using full name.
>

yes but my worries with this approach is that nothing prevent an admin
to load others modules that will use aes_for_ecryptfs. And an admin is
not always aware about a module implementation.

Thanks
-- 
Francis
