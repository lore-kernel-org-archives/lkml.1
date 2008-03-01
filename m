Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbYCAIzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbYCAIzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 03:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYCAIzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:55:43 -0500
Received: from postman.opengroup.org ([192.153.166.6]:38173 "EHLO
	postman.opengroup.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYCAIzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:55:42 -0500
X-Greylist: delayed 722 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2008 03:55:42 EST
Date: Sat, 1 Mar 2008 08:42:21 +0000
From: Geoff Clare <gwc@opengroup.org>
To: Michael Kerrisk <michael.kerrisk@googlemail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, carlos@codesourcery.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
Message-ID: <20080301084221.GA20618@squonk.masqnet>
References: <1204119455.6242.403.camel@lappy> <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org> <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com> <1204305244.6243.111.camel@lappy> <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org> <1204307756.6243.121.camel@lappy> <47C84C6C.2000201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C84C6C.2000201@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (postman.opengroup.org [192.153.166.6]); Sat, 01 Mar 2008 08:42:35 +0000 (GMT)
X-Authenticated-Sender: user gwc from 217.155.142.121
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <michael.kerrisk@googlemail.com> wrote, on 29 Feb 2008:
>
> My reading of POSIX.1 (and POSIX doesn't seem very explicit on this 
> point), is that the limits on argv+environ and on stack are decoupled, 
> since POSIX specifies RLIMIT_STACK and sysconf(_SC_ARG_MAX) and doesn't 
> specify any relationship between the two.

POSIX doesn't specify any relationship between them because (as far
as POSIX is concerned) they are limits on entirely different things.
sysconf(_SC_ARG_MAX) is a limit on how much arg+env a process can
_pass_ to the exec*() functions.  The RLIMIT_* limits are limits on
the process itself.

-- 
Geoff Clare <g.clare@opengroup.org>
The Open Group, Thames Tower, Station Road, Reading, RG1 1LX, England
