Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015AbZKBBOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbZKBBOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 20:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZKBBOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 20:14:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:60936 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbZKBBOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 20:14:32 -0500
Date: Sun, 1 Nov 2009 17:15:42 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] compiler: Introduce __always_unused
Message-ID: <20091101171542.56a44a49@infradead.org>
In-Reply-To: <4AEE2CEC.8040206@cn.fujitsu.com>
References: <4AEE2CEC.8040206@cn.fujitsu.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Nov 2009 08:50:52 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

Hi,

> I wrote some code which is used as compile-time checker, and the
> code should be elided after compile.
> +#define __always_unused
> __attribute__((unused)) 

I have a suggestion.
In addition to marking it attribute unused, would it be useful to also
put a section attribute as part of this, to a section that we can then
drop from the binary by way of the linker script ?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
