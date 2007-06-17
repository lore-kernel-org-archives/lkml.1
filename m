Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbXFQKWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbXFQKWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbXFQKW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 06:22:28 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:44124 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXFQKW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 06:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=btMlyoRjMJKsReTe3iMBntivCGhcOA8wAMM1awCu8UgQAuAgUR7CbuqtIzUSZueKIhRdNweMzS7QmyyQvddpFNDdhmDxMAjuJRzfGnQxuP7MYrY7ocJwYKacDIYfmun/OPFNAHha1gVLY+LPXztF5dKJ70BGS8MjOOpD+vpjtRY=
Message-ID: <6bffcb0e0706170322j3c51868fn6189bfd7d3bcac1@mail.gmail.com>
Date: Sun, 17 Jun 2007 12:22:26 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] (Re: regression tracking (Re: Linux 2.6.21))
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Oleg Verych" <olecom@flower.upol.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070617025552.addd1c41.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <p73d51n1fup.fsf@bingen.suse.de>
	 <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
	 <E1HyipW-0005wJ-0Q@flower>
	 <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>
	 <20070615234202.GP3588@stusta.de>
	 <20070616013236.GA16016@flower.upol.cz>
	 <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de>
	 <467501D0.3090203@googlemail.com>
	 <20070617025552.addd1c41.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 17 Jun 2007 11:41:36 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > +If the patch introduces a new regression and this regression was not fixed
> > +in seven days, then the patch will be reverted.
>
> Those regressions where we know which patch caused them are the easy ones.
> Often we don't know which patch (or even which subsystem merge) is at
> fault.
>
> I think.  How many of the present 2.6.22-rc regressions which you're
> presently tracking have such a well-identified cause?
>

Here lays the problem.

git-bisect is a killer app, people should start using it.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
