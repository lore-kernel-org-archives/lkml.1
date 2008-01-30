Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbYA3I57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbYA3I57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760339AbYA3I5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:57:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760318AbYA3I5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:57:36 -0500
Subject: Re: [PATCH 05/22 -v7] add notrace annotations to vsyscall.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080130031840.829420571@goodmis.org>
References: <20080130031521.258552785@goodmis.org>
	 <20080130031840.829420571@goodmis.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 09:49:38 +0100
Message-Id: <1201682978.28547.165.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 22:15 -0500, Steven Rostedt wrote:
> plain text document attachment
> (mcount-add-x86-vdso-notrace-annotations.patch)
> Add the notrace annotations to some of the vsyscall functions.

Would the VDSO stuff crash a kernel without these annotations and
CONFIG_MCOUNT=y ?

If so, I think it would be best of you placed these annotations before
adding the core code, this would improve bisectability.

