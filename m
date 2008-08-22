Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbYHVWUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbYHVWUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYHVWUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:20:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37483 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbYHVWUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:20:33 -0400
Date: Fri, 22 Aug 2008 15:20:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 22 (hdlc/wanbook)
Message-Id: <20080822152059.c83ea19a.randy.dunlap@oracle.com>
In-Reply-To: <20080822173415.6958cbcc.sfr@canb.auug.org.au>
References: <20080822173415.6958cbcc.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merging hdlc/hdlc-next


Hi Krzysztof,

wanbook.tmpl was removed!?!  why?
Is there some replacement for it or is it just not useful?

I seem to have missed the patch(es) that did this...

Anyway, "make htmldocs" now fails with:

head: cannot open `/local/linsrc/linux-next-20080822/Documentation/DocBook/wanbook.xml' for reading: No such file or directory
make[1]: *** [Documentation/DocBook/wanbook.html] Error 1



Looks like Documentation/DocBook/Makefile was missed in the patch.



---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
