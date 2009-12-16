Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbZLPSxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbZLPSxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZLPSxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:53:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:57090 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851AbZLPSxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:53:36 -0500
Subject: Re: [PATCH 14/14] kernel/exit.c and kernel/panic.c: Remove unused
 NORET_TYPE
From: Peter Zijlstra <peterz@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1260989515.21028.228.camel@laptop>
References: <cover.1260949674.git.joe@perches.com>
	 <29e53e769a3f0b38ea8347b95c8947d3f50ab4c6.1260949674.git.joe@perches.com>
	 <1260989515.21028.228.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 19:53:31 +0100
Message-ID: <1260989611.21028.232.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 19:51 +0100, Peter Zijlstra wrote:
> On Wed, 2009-12-16 at 00:09 -0800, Joe Perches wrote:
> > Make the functions match the prototypes in <linux/kernel.h>
> > It's defined to nothing and useless
> 
> Uhm, why not make it useful again and define it to something like:
> 
> #define NORET_TYPE __attribute__((noreturn))
> 
> except I guess that should come after the function name, not before.
> 
> Annotations that tell a particular function is not supposed to exit
> seems useful to me..

Ah, that got hidden in the header and was done in a different patch.

