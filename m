Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbYIVIMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbYIVIMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYIVIMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 04:12:41 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52033 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbYIVIMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 04:12:41 -0400
Date: Mon, 22 Sep 2008 10:12:39 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
To: Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] List of maintainers (draft #3)
Message-ID: <20080922081239.GA28726@strlen.de>
References: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2002 at 12:54:56PM -0200, Denis Vlasenko wrote:
> After recent discussion on Linux development practices I think it may be
> worthy to have list of lk maintainers. Unlike one included into kernel
> source, this document is meant to be monthly (weekly?) mailed to lkml
> and to be modified whenever new victim wishes to be listed in it
> or someone can no longer devote his time to maintainer work.
I don't see an advantage of a regular mail compared to a file in the
tree, but obviously YMMV.

But another thing really bothers me:  I think there should not be more
than one place I have to look up manually for maintainers.  Currently I
have ~100 easy patches pending and the most time consuming part of
finishing these is looking up the right address to send to send them to.
Currently I already have to check the modified files for a maintainer
entry, MAINTAINERS and the history of the files.

IMHO this could be automated with some effort.  I currently imagine:
 - a MAINTAINERS maintainer?!
 - a certain format to specify a maintainer of a single file in that
   file (e.g. in a specially marked comment) to prevent overloading
   MAINTAINERS
 - maybe a per-directory .maintainers file.
 - add a field to each entry in MAINTAINERS specifying a regular
   expression or shell wildcard of the corresponding files and
   directories.
 - a script that takes a patch and extracts the addresses from the above
   sources (and optionally calls git send-email)
 
If you want to do that with an externally maintained source thats OK for
me, too, provided it eases patch submission.

Best regards
Uwe
