Return-Path: <linux-kernel-owner+w=401wt.eu-S1756994AbZHZHLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbZHZHLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbZHZHLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:11:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940AbZHZHLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:11:15 -0400
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <20090825183119.GC2448@Krystal>
References: <20090825141547.GE6114@nowhere>
	 <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
	 <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere>
	 <20090825173107.GJ6114@nowhere>  <20090825183119.GC2448@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 09:10:02 +0200
Message-Id: <1251270602.7538.1228.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 14:31 -0400, Mathieu Desnoyers wrote:
> For instance, some
> proprietary Linux driver does very odd things with system calls within
> kernel threads, like invoking them with int 0x80.

So who is going to send the x86 patch to make int 0x80 from kernel space
panic the machine? :-)
