Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbZLVTtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbZLVTtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZLVTtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:49:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:35143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbZLVTtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:49:22 -0500
Subject: Re: RFC: A proposal for power capping through forced idle in the
 Linux  Kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Salman Qazi <sqazi@google.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
In-Reply-To: <20091214161922.6f252492@infradead.org>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
	 <20091214161922.6f252492@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:48:24 +0100
Message-ID: <1261511304.4937.116.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 16:19 -0800, Arjan van de Ven wrote:

> I like the general idea, I have one request (that I didn't see quite in
> your explanation): Please make sure that all cpus in the system do
> their idle injection at the same time, so that memory can go into power
> saving mode as well during this time etc etc...

And then you're going to ask that it scales too, right? :-)

Gang-scheduling is inherently non scalable, be it for idle time or not.

