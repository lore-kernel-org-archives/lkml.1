Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbYGVEfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbYGVEfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYGVEe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:34:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYGVEe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:34:57 -0400
Subject: Re: [RFC] schedule_timeout_range()
From: David Woodhouse <dwmw2@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080721212618.42493d12@infradead.org>
References: <1216695757.18980.16.camel@shinybook.infradead.org>
	 <1216695942.18980.19.camel@shinybook.infradead.org>
	 <200807221356.29892.nickpiggin@yahoo.com.au>
	 <1216699922.18980.66.camel@shinybook.infradead.org>
	 <20080721212618.42493d12@infradead.org>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 00:34:42 -0400
Message-Id: <1216701282.18980.67.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 21:26 -0700, Arjan van de Ven wrote:
> On Tue, 22 Jul 2008 00:12:02 -0400
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > How about 'start' and 'end'? Or 'early' and 'late'? I really don't
> > care too much what it's called.
> 
> or "start" and "delta" ?

Yeah, that works -- it certainly makes a lot of sense for the
_userspace_ API to look like that. We could do the same for the
in-kernel one too...

-- 
dwmw2

