Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYAIIA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYAIIA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYAIIAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:00:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49894 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYAIIAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:00:12 -0500
Date: Wed, 9 Jan 2008 08:00:03 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, ananth@in.ibm.com,
       akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@us.ibm.com>, mhiramat@redhat.com,
       davem@davemloft.net, hskinnemoen@atmel.com
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
Message-ID: <20080109080003.GC32560@infradead.org>
References: <20080108063334.GA29385@in.ibm.com> <p73zlvgowwn.fsf@bingen.suse.de> <20080108221802.GD21482@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108221802.GD21482@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 11:18:02PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Ananth N Mavinakayanahalli <ananth@in.ibm.com> writes:
> > >  kernel/kprobes.c        |    2 
> > >  kernel/test_kprobes.c   |  216 ++++++++++++++++++++++++++++++++++++++++++++++++
> > 
> > Can you put this somewhere else please? I know there are already some 
> > test files in kernel/* but imho they all belong into some other 
> > directory.
> 
> agreed - lib/* would be the right place i think - we've got 
> lib/locking-selftest.c already.

Actually the right place would be to have a separate toplevel directory
I think, and a separate menu in the kernel config machinery.  Thay way
tests are in one place and easily spottable.

