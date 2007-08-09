Return-Path: <linux-kernel-owner+w=401wt.eu-S937786AbXHIEng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937786AbXHIEng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 00:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXHIEmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 00:42:33 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:39026 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbXHIEmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 00:42:31 -0400
Message-Id: <20070809043626.830486783@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 09 Aug 2007 00:36:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH 0/5 -v2] Modify lguest32 to make room for lguest64 (version 2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Changes since last version.
  - Move lg.h to include/asm instead (suggested by Rusty Russel)
  - All steps of the series compiles (suggested by Stephen Rothwell)
  - Better ifdef header naming (suggested by Stephen Rothwell)
  - Added Andi Kleen to CC (forgot to on V1)
]

Hi all,

I've been working on lguest64 and in order to do this, I had to move
a lot of the i386 specific out of the way.  Well, the lguest64 port
is still not ready to display, but before Rusty makes too many changes
I would like this in upstream so I don't have to keep repeating my
changes :-)


So this patch series moves lguest32 out of the way for other archs.

-- Steve

-- 
