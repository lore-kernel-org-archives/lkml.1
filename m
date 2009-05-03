Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZECX4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZECX4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZECX4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:56:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:50567 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZECX4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:56:05 -0400
Date: Sun, 3 May 2009 16:58:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, Jake Edge <jake@lwn.net>,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: avoid leaking eip, esp, or wchan to
 non-privileged processes (fwd)
Message-ID: <20090503165817.232c941e@infradead.org>
In-Reply-To: <alpine.LRH.2.00.0905040917240.20251@tundra.namei.org>
References: <alpine.LRH.2.00.0905040917240.20251@tundra.namei.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009 09:27:29 +1000 (EST)
James Morris <jmorris@namei.org> wrote:

> This patch needs some review.

having just gotten back from another trip...

this patch looks relevant, but has a compatibility risk.... Personally
I think it'd be ok, but if things would break we do have some options
that are better than 'do nothing'.

One option to reduce the compatibility risk (as the expense of the
security angle) would be to mask the lower, say 4 to 8 bits of these
variables instead for non-ptrace-capable callers. Other obfuscation
options are obviously also possible.



> 
> Having someone specifically responsible for maintaining kernel memory 
> protection features would be of immense value.  Any takers?

I suppose I could do that.... but would be nice to have a few folks.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
