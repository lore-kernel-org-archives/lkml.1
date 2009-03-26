Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbZCZQXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbZCZQXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZCZQXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:23:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756095AbZCZQXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:23:42 -0400
Date: Thu, 26 Mar 2009 09:15:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Hua Zhong <hzhong@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
Message-Id: <20090326091511.a4e88b2f.akpm@linux-foundation.org>
In-Reply-To: <20090326161019.GT28946@ZenIV.linux.org.uk>
References: <20090325051920.406564281@goodmis.org>
	<20090325052023.071564146@goodmis.org>
	<84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
	<009101c9ad20$1ae231c0$50a69540$@com>
	<1237968394.30175.12.camel@penberg-laptop>
	<84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>
	<20090326161019.GT28946@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 16:10:19 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> We certainly can add explicit check, but that'll keep asking for
> patches "removing useless check".  The same applies to other places,
> really.

Such patches are easily prevented by commenting the exceptional cases.
