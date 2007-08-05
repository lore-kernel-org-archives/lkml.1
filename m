Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbXHESlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbXHESlc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 14:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbXHESlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 14:41:24 -0400
Received: from lazybastard.de ([212.112.238.170]:45162 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXHESlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 14:41:24 -0400
Date: Sun, 5 Aug 2007 20:37:14 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805183714.GA31606@lazybastard.org>
References: <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <20070804202830.GA4538@elte.hu> <20070804210351.GA9784@elte.hu> <20070804225121.5c7b66e0@the-village.bc.nu> <20070805072141.GA4414@elte.hu> <20070805085354.GC6002@1wt.eu> <20070805141708.GB25753@lazybastard.org> <1186336953.2777.17.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1186336953.2777.17.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 August 2007 11:02:33 -0700, Arjan van de Ven wrote:
> 
> but does it work with relatime ?

Like a greased penguin.  I had to reboot with my ugly patch posted
earlier in the patch to actually test it, though.  Relatime suffers from
a distribution problem, nothing else.

Guess I should throw in a kernel compile test as well, just to get a
feel for the performance.

Jörn

-- 
Homo Sapiens is a goal, not a description.
-- unknown
