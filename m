Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbXGIWIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbXGIWIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbXGIWIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:08:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60136 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755422AbXGIWId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:08:33 -0400
Date: Mon, 9 Jul 2007 23:12:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Rob Landley <rob@landley.net>, holzheu@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, jack@suse.cz, kenistoj@us.ibm.com,
       heiko.carstens@de.ibm.com, pavel@ucw.cz, hpa@zytor.com,
       jengelh@computergmbh.de, sam@ravnborg.org, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, lf_kernel_messages@linux-foundation.org,
       tim.bird@am.sony.com, arjan@infradead.org, auke-jan.h.kok@intel.com,
       Valdis.Kletnieks@vt.edu, gregkh@suse.de, linux-kernel@vger.kernel.org,
       joe@perches.com, Andrew Morton <akpm@linux-foundation.org>,
       hansendc@us.ibm.com, davem@davemloft.net
Subject: Re: [Lf_kernel_messages] Re: Documentation of kernel messages
 (Summary)
Message-ID: <20070709231221.6ca80ad9@the-village.bc.nu>
In-Reply-To: <20070709181007.GA2343@thunk.org>
References: <1181747217.29512.9.camel@localhost.localdomain>
	<20070613111549.db1fa4d9.akpm@linux-foundation.org>
	<1182779321.7142.15.camel@localhost.localdomain>
	<200706251144.48658.rob@landley.net>
	<20070709181007.GA2343@thunk.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> Yep, it's going to be up to the translators to keep the message
> catalogs up to date.  The gettext folks have figured out ways of doing
> fuzzy string matches, and so if you keep the external database of
> filename, line #, string, hash, and translation(s), when you go to new
> version of the kernel, it's not that hard to make the fuzzy
> translations work.

The tools can extract the strings if marked _() which is easy work to do
and you usually only want to hit a subset of strings anyway [the ones
that occur usually].

Having implemented an encheferizer in a much older kernel its worth it
even for the humour value of a valspeak kernel (plus some people will
never be happy until it says things like

SYS-E-FOO: Incorrect operating system in use
