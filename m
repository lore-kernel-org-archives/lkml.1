Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZCUUc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZCUUc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 16:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZCUUcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 16:32:47 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:52268 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbZCUUcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 16:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=KbfOhmANJSv6I2MSsZKIq+YjQFCbBVic28yjCXIPvFeB8hctGOxUIdJ+M1dCS4OhWq
         uRTYDVwHs2tDilRVFLEqs+ZSC1FcH1U37SmpvgzN4C/RRqs6/njdkEHexA9qFtFpMEap
         Y+pPhwDiXeteBSy5TD39vKcr4XSsyx2x6AGE0=
From: Diego Calleja <diegocg@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Date: Sat, 21 Mar 2009 21:35:21 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-00124-g5bee17f; KDE/4.2.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu>
In-Reply-To: <20090321154501.GA2707@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903212135.21457.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sábado 21 Marzo 2009 16:45:01 Ingo Molnar escribió:

> The main issue i see is that no kernel developer i work with on a 
> daily basis uses SystemTap - and i work with a lot of people. Yes, i 
> could perhaps name two or three people from lkml using it, but its 
> average penetration amongst kernel folks is essentially zero.

What about userspace developers? People always talks of systemtap as
a kernel thing, but my (humble) impression is that kernel hackers don't
seem to need it that much (maybe for the same reasons they didn't a
kernel debugger ;), but userspace developers do. There're many
userspace projects that offer optional compile options to enable dtrace
probes (some people like apple even ship executables of python, perl
and ruby with probes by default). There're several firefox hackers that
switched to dtrace-capable systems just because the dtrace-javascript
probes enabled them to debug javashit code in ways they weren't able
in linux or windows.

In my humble opinion a better development environment for linux
userspace programmers is way more important than whether kernel
hackers like systemtap or not. So maybe the discussion should be less
about "does it help kernel hackers?" and more about "does it help
userspace hackers?". My 2¢...
