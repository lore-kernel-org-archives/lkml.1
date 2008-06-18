Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYFRV3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYFRV3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYFRV2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:28:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:54663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYFRV2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:28:54 -0400
Date: Wed, 18 Jun 2008 14:28:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Ryan Hope" <rmh3093@gmail.com>
Cc: linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Message-ID: <20080618142849.13e90c6d@infradead.org>
In-Reply-To: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
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

On Wed, 18 Jun 2008 17:15:08 -0400
"Ryan Hope" <rmh3093@gmail.com> wrote:

> I applied the following patches from 2.6-26-rc5-mm3

> 
> I am on an x86_64. I dont know what other info you need...
> 

if it's locking related, enabling LOCKDEP is a first good test to do.

CONFIG_PROVE_LOCKING=y
as well as the various spinlock/mutex lock debug questions



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
