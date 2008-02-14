Return-Path: <linux-kernel-owner+w=401wt.eu-S1765395AbYBNNm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765395AbYBNNm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 08:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYBNNmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 08:42:19 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:41775 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759AbYBNNmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:42:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAG7Us0dMQWYv/2dsb2JhbACBWa0l
Date: Thu, 14 Feb 2008 08:37:17 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spufs support multiple probes markers
Message-ID: <20080214133717.GC27478@Krystal>
References: <20080212152245.2d816143.akpm@linux-foundation.org> <20080212233914.GA22966@Krystal> <20080212235650.GA23693@Krystal> <20080214071908.GA8866@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080214071908.GA8866@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:33:32 up 3 days,  9:34,  4 users,  load average: 0.06, 0.20,
	0.25
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Tue, Feb 12, 2008 at 06:56:50PM -0500, Mathieu Desnoyers wrote:
> > Update spufs to the new linux kernel markers API, which supports connecting
> > more than one probe to a single marker.
> 
> Compiles and works for me.  But saying I like the odd API would be lying.
> 

Are there any concerns of yours that I should address then ? The changes
I made to the probe function prototype appeared to be technically
required and caused by variadic argument limitations when it comes to
support multiple probes.

I think that the marker arm/disarm removal gets rid of an unnecessary
redundancy.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
