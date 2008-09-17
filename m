Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYIQUNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYIQUNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 16:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYIQUN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 16:13:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbYIQUN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 16:13:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=YOOy7kD226DBvrZsZ4AjL4k1Xnksj0Xk+F7W0+e/yAD3Lqd16QiKKgjRKa5cQb5XP
	7WffwUsIK5vzd2+os9wXQ==
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20080917191333.6FA7E640A5@pipsqueak.localdomain>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	 <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu>
	 <1221502142.19012.35.camel@bobble.smo.corp.google.com>
	 <20080916084143.GC17287@elte.hu>
	 <1221678187.13420.17.camel@bobble.smo.corp.google.com>
	 <20080917191333.6FA7E640A5@pipsqueak.localdomain>
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 17 Sep 2008 13:12:31 -0700
Message-Id: <1221682351.13420.19.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-17 at 12:13 -0700, Roland McGrath wrote:
> I had been thinking not so much about code size, but about the unnecessary
> indirection and allocation for the UP case.  I'm happy to defer to Ingo on
> whether to worry about that.

Yeah, I was just responding to his request for a code-size check.  I'm
okay either way, although making the data structures consistent between
the two cases does simplify the code a bit.

The next patch is waiting on Ingo's verdict. :-)
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

