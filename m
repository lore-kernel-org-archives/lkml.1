Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbXGIPbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbXGIPbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbXGIPbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:31:05 -0400
Received: from [212.12.190.92] ([212.12.190.92]:34221 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753740AbXGIPbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:31:03 -0400
From: Al Boldi <a1426z@gawab.com>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Fwd: Re: RAID performance is not too well....
Date: Mon, 9 Jul 2007 18:30:51 +0300
User-Agent: KMail/1.5
References: <20070709113916.GA9781@bitwizard.nl>
In-Reply-To: <20070709113916.GA9781@bitwizard.nl>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091830.51707.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rogier Wolff wrote:
> > >I have an application that creates some 228 thousand files,
> > >spread over about 4000 directories. Total is not more than
> > >1.3Gb.  (I'm not sure, and I don't care if it's 10% or 90% of
> > >that number)
> > >
> > >Anyway, I've loaded all of the 1.3Gb into the cache (the machine
> > >has 8Gb of RAM), so that only writes need to take place.
> > >
> > >After a while the machine goes into a routine of writing
> > >about 500 to 1000kbytes per second.
> > >
> > >Sync seems to take a long time:

The as-iosched has a sync bug, and if you are using that, then try deadline 
instead.


Thanks!

--
Al

