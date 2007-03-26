Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbXCZJlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbXCZJlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXCZJlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:41:23 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:39928 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbXCZJlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:41:22 -0400
Date: Mon, 26 Mar 2007 11:41:20 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] add file position info to proc
Message-ID: <20070326094120.GD741@vanheusden.com>
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu> <20070325154541.6dcbd291.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070325154541.6dcbd291.akpm@linux-foundation.org>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Sun Mar 18 00:02:24 CET 2007
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to me with PGP!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch adds support for finding out the current file position,
> > open flags and possibly other info in the future.
> > These new entries are added:
> > 
> >   /proc/PID/fdinfo/FD
> >   /proc/PID/task/TID/fdinfo/FD
> > For each fd the information is provided in the following format:
> > pos:	1234
> > flags:	0100002
> 
> I've seen the idea mentioned once or twice, but not with any great
> enthusiasm.  Why does Linux want this feature?

Well, it happened quiet a few times that I started some perlscript
parsing a few GB of data and forgot to add some progress counter.
When after an hour of processing the script still has not stopped, I'd
like to see how much it processed so that I can estimate how long I
still have to wait and if it is worthwhile to stop the script for
optimalisations and such.


Folkert van Heusden

-- 
MultiTail è uno flexible tool per seguire di logfiles e effettuazione
di commissioni. Feltrare, provedere da colore, merge, 'diff-view',
etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
