Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYGIUk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYGIUk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYGIUkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:40:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:44845 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYGIUkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:40:47 -0400
Date: Wed, 9 Jul 2008 13:39:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709133958.612635f0@infradead.org>
In-Reply-To: <48751B57.8030605@goop.org>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<m1abgqzv3g.fsf@frodo.ebiederm.org>
	<20080709200757.GD14009@elte.hu>
	<48751B57.8030605@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 13:11:03 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > Note that the zero-based percpu problems are completely unrelated
> > to stackprotector. I was able to hit them with a
> > stackprotector-disabled gcc-4.2.3 environment.
> 
> The only reason we need to keep a zero-based pda is to support 
> stack-protector.  If we drop drop it, we can drop the pda - and its 
> special zero-based properties - entirely.

what's wrong with zero based btw?

do they stop us from using gcc's __thread keyword for per cpu variables
or something? (*that* would be a nice feature)

or does it stop us from putting the per cpu variables starting from
offset 4096 onwards?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
