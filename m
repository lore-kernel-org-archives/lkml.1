Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYIVJNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYIVJNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYIVJNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:13:30 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57023 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751543AbYIVJNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:13:30 -0400
Date: Mon, 22 Sep 2008 10:12:56 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Uwe Kleine-K?nig <ukleinek@strlen.de>
Cc: Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] List of maintainers (draft #3)
Message-ID: <20080922091256.GH1916@fluff.org.uk>
References: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua> <20080922081239.GA28726@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922081239.GA28726@strlen.de>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 10:12:39AM +0200, Uwe Kleine-K?nig wrote:
> On Thu, Feb 07, 2002 at 12:54:56PM -0200, Denis Vlasenko wrote:
> > After recent discussion on Linux development practices I think it may be
> > worthy to have list of lk maintainers. Unlike one included into kernel
> > source, this document is meant to be monthly (weekly?) mailed to lkml
> > and to be modified whenever new victim wishes to be listed in it
> > or someone can no longer devote his time to maintainer work.
> I don't see an advantage of a regular mail compared to a file in the
> tree, but obviously YMMV.
> 
> But another thing really bothers me:  I think there should not be more
> than one place I have to look up manually for maintainers.  Currently I
> have ~100 easy patches pending and the most time consuming part of
> finishing these is looking up the right address to send to send them to.
> Currently I already have to check the modified files for a maintainer
> entry, MAINTAINERS and the history of the files.
> 
> IMHO this could be automated with some effort.  I currently imagine:
>  - a MAINTAINERS maintainer?!
>  - a certain format to specify a maintainer of a single file in that
>    file (e.g. in a specially marked comment) to prevent overloading
>    MAINTAINERS
>  - maybe a per-directory .maintainers file.

I was thinking of at least making MAINTAINERS per-subsystem, it is a
large file and would be easier for the people submitting patcehs to
avoid having to touch a common file.

>  - add a field to each entry in MAINTAINERS specifying a regular
>    expression or shell wildcard of the corresponding files and
>    directories.
>  - a script that takes a patch and extracts the addresses from the above
>    sources (and optionally calls git send-email)

I think that is also a good idea.
  
> If you want to do that with an externally maintained source thats OK for
> me, too, provided it eases patch submission.
> 
> Best regards
> Uwe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
