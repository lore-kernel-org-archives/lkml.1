Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbXHTUJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbXHTUJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXHTUJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:09:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbXHTUJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:09:08 -0400
Date: Mon, 20 Aug 2007 16:08:56 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Roland McGrath <roland@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [POWERPC] Fix for assembler -g
Message-ID: <20070820200856.GA4194@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Roland McGrath <roland@redhat.com>,
	Paul Mackerras <paulus@samba.org>
References: <200708181959.l7IJxJ5q020206@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708181959.l7IJxJ5q020206@hera.kernel.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 07:59:19PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=55a910a81d0c3014abc20b9efa73c595b3e68339
 > Commit:     55a910a81d0c3014abc20b9efa73c595b3e68339
 > Parent:     aa1cf632bd6f998cb4567ccf1a9d2e5daaa9fb44
 > Author:     Roland McGrath <roland@redhat.com>
 > AuthorDate: Sat Aug 11 09:03:11 2007 +1000
 > Committer:  Paul Mackerras <paulus@samba.org>
 > CommitDate: Wed Aug 15 15:12:50 2007 +1000
 > 
 >     [POWERPC] Fix for assembler -g
 >     
 >     ppc64 does the unusual thing of using #include on a compiler-generated
 >     assembly file (lparmap.s) from an assembly source file (head_64.S).
 >     This runs afoul of my recent patch to pass -gdwarf2 to the assembler
 >     under CONFIG_DEBUG_INFO.  This patch avoids the problem by disabling
 >     DWARF generation (-g0) when producing lparmap.s.
 >     
 >     Signed-off-by: Roland McGrath <roland@redhat.com>
 >     Signed-off-by: Paul Mackerras <paulus@samba.org>

I'm still seeing failures with this.
http://koji.fedoraproject.org/koji/getfile?taskID=110854&name=build.log
shows..

lparmap.c: Assembler messages:
lparmap.c:84: Error: file number 1 already allocated
make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1

Anything I can provide to help diagnose this?

	Dave

-- 
http://www.codemonkey.org.uk
