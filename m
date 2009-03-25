Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZCYIGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZCYIGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZCYIGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:06:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53735 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbZCYIGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:06:38 -0400
Subject: RE: [PATCH 2/5] mm: remove unlikly NULL from kfree
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Steven Rostedt'" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Roland McGrath'" <roland@redhat.com>,
       "'Nick Piggin'" <nickpiggin@yahoo.com.au>,
       "'Steven Rostedt'" <srostedt@redhat.com>,
       "'Christoph Lameter'" <cl@linux-foundation.org>,
       "'Matt Mackall'" <mpm@selenic.com>
In-Reply-To: <009101c9ad20$1ae231c0$50a69540$@com>
References: <20090325051920.406564281@goodmis.org>
	 <20090325052023.071564146@goodmis.org>
	 <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
	 <009101c9ad20$1ae231c0$50a69540$@com>
Date: Wed, 25 Mar 2009 10:06:34 +0200
Message-Id: <1237968394.30175.12.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 01:02 -0700, Hua Zhong wrote:
> > But those are _error handling paths_ (at least supposed to be). I
> > wonder which call-sites are responsible for this. Can frtrace help us
> > here?
> 
> I am not sure why you call these error paths.
> 
> I submitted the same patch two years ago, and you are still holding the same
> argument.
> 
> http://www.archivum.info/linux.kernel/2006-04/msg06042.html
> 
> Have you used likely profiler? These are real numbers. If you insist on
> calling them error paths then error paths are obviously the norm.

I am not denying the results, I am just saying that they don't make much
sense to me. Like I said, I would love to see the actual call-sites to
prove my argument wrong.

			Pekka

