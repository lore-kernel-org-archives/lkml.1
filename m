Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZGXVSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZGXVSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZGXVSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:18:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41700 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbZGXVSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:18:02 -0400
Date: Fri, 24 Jul 2009 17:17:56 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Nick Dokos <nicholas.dokos@hp.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com, agk@redhat.com
Subject: Re: Regression in 2.6.31-rc3 (and presumably 2.6.31-rc4?)
Message-ID: <20090724211756.GA21441@redhat.com>
References: <1248467055.7964.12.camel@cail> <8899.1248467518@alphaville.usa.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8899.1248467518@alphaville.usa.hp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24 2009 at  4:31pm -0400,
Nick Dokos <nicholas.dokos@hp.com> wrote:

> Alan D. Brunelle <Alan.Brunelle@hp.com> wrote:
> 
> > I did a diffstat between 2.6.31-rc3 and -rc4 and didn't see anything in
> > the MD space, so...
> > 
> > I am unable to create multi-disk LVM striped-volumes with this commit in
> > place - Nick Dokos @ HP did the bisecting and found that removing this
> > commit fixes the same problem for him:
> > 
> > 754c5fc7ebb417b23601a6222a6005cc2e7f2913 is first bad commit
> > commit 754c5fc7ebb417b23601a6222a6005cc2e7f2913
> > Author: Mike Snitzer <snitzer@redhat.com>
> > Date:   Mon Jun 22 10:12:34 2009 +0100
> > 
> >     dm: calculate queue limits during resume not load
> > 
> 
> I pulled from agk's tree after seeing his pull request and applied
> commit 5dea271b6d87bd1d79a59c1d5baac2596a841c37 (plus two more) on
> top of 2.6.41-rc4: I don't see the problem any longer.

Yes, this issue was fixed by that commit (5dea271b6d8).  The fix was
first posted to dm-devel 3 weeks ago:
https://www.redhat.com/archives/dm-devel/2009-July/msg00008.html

Regards,
Mike
