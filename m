Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbZAPKJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbZAPKJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbZAPKJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:09:27 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:37664 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbZAPKJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:09:26 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 27/85] [PATCH 07/44] [CVE-2009-0029] System call wrapper infrastructure
Date: Fri, 16 Jan 2009 11:09:21 +0100
User-Agent: KMail/1.9.9
Cc: Jiri Slaby <jirislaby@gmail.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ralf Baechle <ralf@linux-mips.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20090115215237.906089480@mini.kroah.org> <200901160944.59773.borntraeger@de.ibm.com> <20090116095747.GE5157@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090116095747.GE5157@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161109.21880.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 16 Januar 2009 schrieb Heiko Carstens:
> > I see two possible quick fixes:
> > -funit-at-a-time will allow these inline constructs (tested with 3.4.6 on 
i386 
> > with enabled syscall wrappers. x86_64 already sets this flag)
> 
> If that helps: care to send a patch that enables this?
> Dependent on CONFIG_HAVE_SYSCALL_WRAPPERS?

I could do that, but...

> That is, if this is really a problem.

..I dont know if this is really a problem. i386 is the only architecture where 
I was able to reproduce the inline problem. But i386 does not set 
SYSCALL_WRAPPERS so the problem goes away.

I suggest to wait for a patch until we know of an architecture that is 
affected (inline problem + HAVE_SYSCALL_WRAPPERS set).
