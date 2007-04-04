Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXDDSmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXDDSmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXDDSmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:42:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51892 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbXDDSmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:42:47 -0400
Date: Wed, 4 Apr 2007 11:41:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       ego@in.ibm.com, paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com, Roland McGrath <roland@redhat.com>
Subject: Re: utrace merge
Message-Id: <20070404114132.4d563267.akpm@linux-foundation.org>
In-Reply-To: <20070404103624.GA509@infradead.org>
References: <20070402053457.GA9076@in.ibm.com>
	<20070402061612.GA7072@elte.hu>
	<20070403120104.GB29308@in.ibm.com>
	<200704032134.29720.rjw@sisk.pl>
	<20070403132427.88308b59.akpm@linux-foundation.org>
	<20070404100644.GC19120@elte.hu>
	<20070404103624.GA509@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 11:36:24 +0100 Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Apr 04, 2007 at 12:06:44PM +0200, Ingo Molnar wrote:
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > urgh, I screwed up, sorry.
> > > 
> > > utrace-prep-2 reverts a bit of the underlying tree so that the utrace 
> > > patches (which are against mainline) don't throw a tremendous reject 
> > > which has to be fixed each time I pull Roland's tree.  I'm supposed to 
> > > reapply that change after the utrace patches but forgot.
> > 
> > btw., how about pushing utrace to v2.6.22, is anything big holding that 
> > up? (other than Roland's modesty, which we should gently but firmly 
> > ignore in this case =B-)
> 
> a) lots of architecture support
> b) lots of overengineered and obsfucated code
> c) missing public information
> 
> I've also not gotten any feedback to my ages old review and the issues
> don't seem to be addressed either.
> 

And rmk had showstopper problems with ARM support which I never
saw resolved.
