Return-Path: <linux-kernel-owner+w=401wt.eu-S2992841AbXDDLJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992841AbXDDLJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992843AbXDDLJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:09:35 -0400
Received: from aun.it.uu.se ([130.238.12.36]:46463 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992841AbXDDLJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:09:35 -0400
Date: Wed, 4 Apr 2007 13:08:36 +0200 (MEST)
Message-Id: <200704041108.l34B8ag5019443@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: utrace merge
Cc: dino@in.ibm.com, dipankar@in.ibm.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
       oleg@tv-sign.ru, paulmck@us.ibm.com, rjw@sisk.pl, roland@redhat.com,
       torvalds@linux-foundation.org, vatsa@in.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 12:06:44 +0200, Ingo Molnar wrote:
> btw., how about pushing utrace to v2.6.22, is anything big holding that 
> up?

IMO, until regressions in the ptrace userspace API like
<https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229112>
are eliminated, utrace must not replace ptrace in the vanilla kernel.

/Mikael
