Return-Path: <linux-kernel-owner+w=401wt.eu-S1764778AbXFRTiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764778AbXFRTiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761435AbXFRTh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:37:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759353AbXFRThz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:37:55 -0400
To: david@lang.hm
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706161817.36657.dhazelton@enter.net>
	<orodjfmjsr.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706162306.14516.dhazelton@enter.net>
	<orwsy3l0jv.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617051451.GD21478@ftp.linux.org.uk>
	<orps3vjf93.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070618154549.GB6041@kroah.com>
	<orabuxcefc.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706181122410.12717@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 16:20:18 -0300
In-Reply-To: <Pine.LNX.4.64.0706181122410.12717@asgard.lang.hm> (david@lang.hm's message of "Mon\, 18 Jun 2007 11\:32\:41 -0700 \(PDT\)")
Message-ID: <orodjdax3h.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, david@lang.hm wrote:

> do you realize that redhat uses checksums or signatures to check the
> validity of their CD's?

Yes.  How does this stop the users from enjoying any of the freedoms?

> I seriously doubt if redhat tells you how to how to generate such a
> checksum/signature.

Mixing two different issues here.

The checksums embedded in the ISO images are implemented in anaconda
itself, provided along with the distro, so anyone can generate them,
even though I don't know the precise algorithm.  The checksums over
the ISO images themselves are implemented with sha1sum (earlier,
md5sum), so anyone can generate them too.

As for the GPG signatures in the RPMs and in the SHA1SUM file, these
are indeed generated using public algorithms but private keys.  But
these signatures are not functional, and they don't in any way stop
anyone from enjoying freedoms.

> in addition to the problem that Linus points out about being unable to
> change the contents of the write-only CD this would seem to conflict
> with what you are claiming the GPL is supposed to allow.

It looks like you read only Linus' messages, not my responses.  A
write-only CD is like ROM.  It's not the distributor who's imposing
restrictions on its modification.  Nobody can modify it because nature
says so.  It's not like the software is being recorded in a CD as a
means to prevent you from modifying it.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
