Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZCYIDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZCYIDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbZCYIDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:03:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:52219 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZCYIDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=VulZQUxGbeQuLEwPvPqeG8omX0IRU0x5mx0sUa2dRQ4lz9LiTKlkCTIvWkKpWgcMT6
         V4nk5rSL2hfBDPX1OMD3HMz/SU9/PXKt2myIs3CH9fJYNEurQconhkai5LP/Xx+foFQU
         /AgwKuJtJNRNVEwSAnkRmTvycGbjtPORt72mM=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Pekka Enberg'" <penberg@cs.helsinki.fi>,
       "'Steven Rostedt'" <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Roland McGrath'" <roland@redhat.com>,
       "'Nick Piggin'" <nickpiggin@yahoo.com.au>,
       "'Steven Rostedt'" <srostedt@redhat.com>,
       "'Christoph Lameter'" <cl@linux-foundation.org>,
       "'Matt Mackall'" <mpm@selenic.com>
References: <20090325051920.406564281@goodmis.org>	 <20090325052023.071564146@goodmis.org> <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
In-Reply-To: <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
Subject: RE: [PATCH 2/5] mm: remove unlikly NULL from kfree
Date: Wed, 25 Mar 2009 01:02:54 -0700
Message-ID: <009101c9ad20$1ae231c0$50a69540$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcmtHCxCVLnLkePDQ9aupRJGqHXj7wAA7Cmg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But those are _error handling paths_ (at least supposed to be). I
> wonder which call-sites are responsible for this. Can frtrace help us
> here?

I am not sure why you call these error paths.

I submitted the same patch two years ago, and you are still holding the same
argument.

http://www.archivum.info/linux.kernel/2006-04/msg06042.html

Have you used likely profiler? These are real numbers. If you insist on
calling them error paths then error paths are obviously the norm.

Hua


