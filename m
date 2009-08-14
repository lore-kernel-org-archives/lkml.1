Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbZHNM4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbZHNM4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbZHNM4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:56:08 -0400
Received: from www.lumino.de ([85.159.12.10]:49861 "HELO imap.lumino.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756716AbZHNM4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:56:08 -0400
Message-ID: <4A855EE5.9010105@lumino.de>
Date: Fri, 14 Aug 2009 14:56:05 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jakub Jelinek <jakub@redhat.com>, Thomas Chou <thomas@wytron.com.tw>
Subject: Re: implementing Futex
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de> <4A8550CF.8000003@lumino.de> <200908141438.01392.arnd@arndb.de>
In-Reply-To: <200908141438.01392.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> The man page says that the last parameter is ignored for op=FUTEX_WAKE,
> which is correct. The code that you were looking at however is for
> of=FUTEX_WAKE_OP, which is not documented as of manpages-3.22.
> 
> It was added by Jakub back in 2005, but if he wrote a documentation
> for it, it never went into the man pages package. On a similar
> note, Ingo also added other futex operations that are not documented
> yet.
> 

Thus in any documented software, the quite complex stuff in
"futex_atomic_op_inuser", which is provided in several different
"futex.h" files for all those architectures *never* is used ?

Weired !

Is there any viable use for this ?

Would it not be appropriate either to do a documentation or to remove it ?

-Michael
