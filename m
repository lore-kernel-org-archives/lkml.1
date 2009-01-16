Return-Path: <linux-kernel-owner+w=401wt.eu-S937047AbZAPUPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937047AbZAPUPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZAPUPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:15:07 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58918 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755379AbZAPUPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:15:06 -0500
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Grant Grundler <grundler@google.com>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <da824cf30901161209k7fa2d1cau27a2152c74256c4e@mail.gmail.com>
References: <1232117771.3224.21.camel@localhost.localdomain>
	 <20090116090928.e43c986e.akpm@linux-foundation.org>
	 <da824cf30901161102r67b9c31euc12fc95fb8330a07@mail.gmail.com>
	 <20090116.111059.205876014.davem@davemloft.net>
	 <da824cf30901161209k7fa2d1cau27a2152c74256c4e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 15:15:00 -0500
Message-Id: <1232136901.3224.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 12:09 -0800, Grant Grundler wrote:
> On Fri, Jan 16, 2009 at 11:10 AM, David Miller <davem@davemloft.net> wrote:
> ...
> >>
> >> TBH, I still wouldn't implement it the way LSI maintainers did.
> >> I'm happy they are the maintainers and it's their call.
> >
> > They are doing things which effect the entire system, not just
> > their driver.  So this doesn't fall under "maintainer's rights"
> 
> Agreed. This case is about a debug option which is normally disabled.
> So most people will never see this.
> 
> The thread was more about how to make the failure visible in a
> sane way WITHOUT the debug flag enabled. Then when the
> debug flag is enabled, panic the machine as well.
> 
> > If they fail locally, that's fine and perfectly expected, but to take
> > the whole machine out is another matter altogether.
> 
> Agreed.

Me too, but I rejected half of the LSI update because of other problems.
Since this is isolated to actual firmware debugging, which no normal
user will see, I let it go after a bit of arguing.

James


