Return-Path: <linux-kernel-owner+w=401wt.eu-S936206AbXJQDVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206AbXJQDVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760704AbXJQDVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:21:41 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:31776 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753406AbXJQDVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:21:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=FKvsgMbBc8iRlYDvGMV1hhcrqEL60jXH6QIfkyX1j/lEpT0zwbMFvGISHEJynZd0tdc6HeuWmuTIF9EhJ1ZDOXmpsLlqOpw0GuxtoG8DjWA9o3VeDTUnTcJPzu5feMkrhPkqROrdy0Og9dpPltqaroNFUgInVewGg1a1KEpk7l4=  ;
X-YMail-OSG: Ewl1oVkVM1m9ociyb99hJs1.xKYidog3QC84r6ghRjSSg_aPVet0.HAICxI0YkwAVfMUgz4qLQ--
Date: Tue, 16 Oct 2007 20:21:38 -0700
From: David Brownell <david-b@pacbell.net>
To: viro@ftp.linux.org.uk
Subject: Re: [PATCH] missing include in mmc
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20071017000907.GF8181@ftp.linux.org.uk>
 <20071017002551.3577B23B309@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071017020445.GG8181@ftp.linux.org.uk>
In-Reply-To: <20071017020445.GG8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071017032139.17D6323A687@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > AFAICS, fallout from repacing include of blkdev.h with include of bio.h.
> > 
> > Out of curiousity, which architecture(s) need this?
>
> Umm...   IIRC, m32r had been the first build to step into that, at which point
> the missing include had been added; the rest had reached that point later, so
> I'm not sure which ones would trigger the same crap.  Not hard to test,
> though...
>
> Aha.  m68k as well.

FWIW this driver originally started out on ColdFire (m68k derived),
a few years back.  :)

Every time I seee a case where architectures don't act the same
with respect to #includes, I count it as an unpleasant surprise.
Not one that's very easy to avoid, unfortunately, but I think it's
been happening less often lately.

Thanks for the fix.

- Dave

