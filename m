Return-Path: <linux-kernel-owner+w=401wt.eu-S934034AbXKOWpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbXKOWpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762230AbXKOWp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:45:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376AbXKOWp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:45:26 -0500
Date: Thu, 15 Nov 2007 14:44:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH] FRV: Fix the extern declaration of kallsyms_num_syms
 [try #2]
Message-Id: <20071115144408.ba545d99.akpm@linux-foundation.org>
In-Reply-To: <20071115144007.08760570.akpm@linux-foundation.org>
References: <20071113165316.18700.67752.stgit@warthog.procyon.org.uk>
	<20071115144007.08760570.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 14:40:07 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> But it all strikes me as a bit fragile and grotty.  Perhaps longer-term it
> would be better if scripts/kallsyms.c were to also emit a header file which
> declares all the things which that program emits the definitions of, no?
> 
> I guess that means that we'd need to run the program twice - once at the
> start of compilation in generate-the-header-file mode and once at the end
> of compilation in generate-the-symbols mode.

Although given that this header file will be the same each time that
program is run, we might as well just type the thing in.  And remember to
keep it in sync with changes to scritps/kallsyms output?
