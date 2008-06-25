Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYFYEuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYFYEuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759909AbYFYEpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:45:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:32926 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758855AbYFYEpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:45:05 -0400
Date: Tue, 24 Jun 2008 21:44:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 03 of 36] x86: add memory barriers to wrmsr
Message-ID: <20080624214441.13202f12@infradead.org>
In-Reply-To: <93c7057b1f4acae501b2.1214367539@localhost>
References: <patchbomb.1214367536@localhost>
	<93c7057b1f4acae501b2.1214367539@localhost>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 00:18:59 -0400
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> wrmsr is a special instruction which can have arbitrary system-wide
> effects.  We don't want the compiler to reorder it with respect to
> memory operations, so make it a memory barrier.

it's more readable for several of these cases to stick a barrier(); in
front and after it to be honest; that makes it more explicit that
these are deliberate compiler barriers rather than "actual" memory
access...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
