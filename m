Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbXFZEKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbXFZEKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 00:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbXFZEKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 00:10:46 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:34147 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXFZEKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 00:10:46 -0400
Date: Tue, 26 Jun 2007 00:10:13 -0400
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Message-ID: <20070626041013.GG24745@delft.aura.cs.cmu.edu>
Mail-Followup-To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
	linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKCEKCEMAC.davids@webmaster.com> <or4pl0iz15.fsf@oliva.athome.lsd.ic.unicamp.br> <20070622013417.GT21478@ftp.linux.org.uk> <20070622041949.GA15625@thunk.org> <orejk4edfl.fsf@oliva.athome.lsd.ic.unicamp.br> <20070625132853.GH10008@csclub.uwaterloo.ca> <orhcov7qsz.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orhcov7qsz.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 04:54:52PM -0300, Alexandre Oliva wrote:
> Consider this scenario: vendor tivoizes Linux in the device, and
> includes the corresponding sources only in a partition that is
> theoretically accessible using the shipped kernel, but that nothing in
> the software available in the machine will let you get to.  Further,
> sources (like everything else on disk) are encrypted, and you can only

Interesting scenario, it seems to comply with GPLv2 on the surface.

If that kernel doesn't actually allow access and wipes the source
partition to use it as swap on first boot, then no machine is actually
capable of reading the source. So it isn't really machine readable.
Another gripe is that encrypted media are not customarily used for
software interchange. So that's 2 (minor) strikes where this method of
distribution doesn't seem to match the language of section 3a.

You also cannot interpret the encrypted partition as source code because
a bit further down in section 3, it defines source code as,
  "The source code for a work means the preferred form of the work for
  making modifications to it."

So now we get to section 6. The recipient receives a license to copy,
distribute or modify. You may not impose further restrictions on
these rights granted herein.

You could argue that they do not restrict copying, distribution
and modification of the sources in general, only of the specific copy
they distribute. However here we go back to section 2 which states that
their modified copy is a derived work which must be licensed under the
GPLv2, so that would make it specific enough that recipients have in
fact been granted the right to copy, distribute and modify the copy of
the source of that corresponds to the distributed binaries, which is
restricted because of the encryption which prevents the user to copy,
distribute or modify the source code.

> Does anyone think this is permitted by the letter of GPLv2?

No.

> How are the sources passed on in this way going to benefit the user or
> the community?

Not a really interesting question if the method of distribution violates
the letter of the GPLv2, is it? They get sued for copyright infringement
because they are not in compliance with section 3 and the sources are
released as a result.

Jan

