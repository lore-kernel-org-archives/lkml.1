Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbYFWRWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbYFWRWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYFWRWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:22:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:6199 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbYFWRWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=nRdxxJCFVJYkmDWUB+zlmITNkX+6XZ8UDg/VHqB6u8PY1XkY9kC29S3/uTbYcppH2p
         lmV/pYibO2KbA35Yx5XIy1e1J4iZwXVft/jzhh5LeMjc1igTg3PMs9/D6vdfWKI3B/Zt
         LPD6ZqAsLOUWhPJSPLYBYJaPyq7PzOOG3SYj4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
Date: Mon, 23 Jun 2008 19:22:10 +0200
User-Agent: KMail/1.8.2
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
References: <1209577322.25560.402.camel@pmac.infradead.org> <87bq3rgq40.fsf@basil.nowhere.org> <1209582709.25560.441.camel@pmac.infradead.org>
In-Reply-To: <1209582709.25560.441.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231922.10864.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2008 21:11, David Woodhouse wrote:
> On Wed, 2008-04-30 at 20:22 +0200, Andi Kleen wrote:
> > David Woodhouse <dwmw2@infradead.org> writes:
> > 
> > > Andrew Morton has been saying recently that we need an 'embedded
> > > maintainer', to take responsibility for 'embedded issues' in the core
> > > kernel, as well as trying to improve our relationship with those using
> > > the Linux kernel for 'embedded' devices -- who have a reputation of
> > > not working with us very closely; to their detriment as well as our
> > > own.
> > 
> > I hope your job description doesn't include adding more and more
> > CONFIGs though.
> > 
> > I am sure there are lots of low hanging fruit where memory can be
> > saved and it's a good thing someone cares about that, but please don't
> > focus on the code size only. Or if you work on that don't do it 
> > using CONFIG or when you really add a new one find some other 
> > that is pointless and remove it first. 
> > 
> > There are simply already far too many of them and they make the 
> > kernel harder and harder to change.
> 
> I agree. And if we do want to pay attention to pure code size, there are
> other approaches -- like --gc-sections

I have some patches in this area too. Were submitted to Sam
but he was too busy it seems.
--
vda
