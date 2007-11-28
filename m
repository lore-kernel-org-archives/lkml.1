Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbXK1NKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbXK1NKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXK1NJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:09:57 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44130 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756413AbXK1NJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:09:57 -0500
To: mingo@elte.hu
CC: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <20071128125030.GB21791@elte.hu> (message from Ingo Molnar on
	Wed, 28 Nov 2007 13:50:30 +0100)
Subject: Re: -rt doesn't compile for UML
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128125030.GB21791@elte.hu>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1IxMfh-0006fN-HQ@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Nov 2007 14:09:45 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> * Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > When writing a big file to a ubd disk, everything in uml slows down to
> > a crawl, even though CPU usage is minimal.
> > 
> > So I wanted to try the latency tracer from -rt, but it doesn't compile 
> > with UML:
> 
> note that there are standalone patches as well:
> 
>  http://people.redhat.com/mingo/latency-tracing-patches/
> 
> so there's no forced need to use -rt.

Ah, forgotten about that.

Unfortunately the latency tracer patch doesn't compile either:

  CC      kernel/latency_trace.o
kernel/latency_trace.c:28:21: error: asm/rtc.h: No such file or directory
kernel/latency_trace.c:63:3: error: #error Implement cycles_to_usecs.
kernel/latency_trace.c: In function ‘____trace’:
kernel/latency_trace.c:658: error: implicit declaration of function ‘irqs_disabled_flags’
make[1]: *** [kernel/latency_trace.o] Error 1

Miklos
