Return-Path: <linux-kernel-owner+w=401wt.eu-S1765017AbXETAP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765017AbXETAP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 20:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbXETAPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 20:15:50 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:57617 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbXETAPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 20:15:49 -0400
Date: Sun, 20 May 2007 02:15:48 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [RFC] log out-of-virtual-memory events
Message-ID: <20070520001548.GK14578@vanheusden.com>
References: <464C81B5.8070101@users.sourceforge.net> <464C9D82.60105@redhat.com> <464D5AA4.8080900@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464D5AA4.8080900@users.sourceforge.net>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Thu May 17 15:24:18 CEST 2007
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> I'm looking for a way to keep track of the processes that fail to
> >> allocate new
> >> virtual memory. What do you think about the following approach
> >> (untested)?
> > Looks like an easy way for users to spam syslogd over and
> > over and over again.
> > At the very least, shouldn't this be dependant on print_fatal_signals?
> 
> Anyway, with print-fatal-signals enabled a user could spam syslogd too, simply
> with a (char *)0 = 0 program, but we could always identify the spam attempts
> logging the process uid...

Yeah well it's all captured by syslogd/klogd and written to a file and
diskspace is cheap.


Folkert van Heusden

-- 
Feeling generous? -> http://www.vanheusden.com/wishlist.php
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
