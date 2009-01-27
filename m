Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbZA0F1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbZA0F1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbZA0F0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:26:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739AbZA0F0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:26:52 -0500
Date: Mon, 26 Jan 2009 21:26:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Bartelmus <lirc@bartelmus.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] export get_task_comm()
Message-Id: <20090126212615.2658b29e.akpm@linux-foundation.org>
In-Reply-To: <20090127051919.GA5034@bombadil.infradead.org>
References: <20090120071641.B0A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<AuEeLWHZjFB@christoph>
	<20090128140615.D464.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20090126211655.c7287768.akpm@linux-foundation.org>
	<20090127051919.GA5034@bombadil.infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 00:19:19 -0500 Kyle McMartin <kyle@infradead.org> wrote:

> On Mon, Jan 26, 2009 at 09:16:55PM -0800, Andrew Morton wrote:
> > Ho hum, I suppose so.  I redid the changelog a bit:
> > 
> >    task_struct.comm[] is useful for debugging and driver developers
> >    want to use this information easily.  Direct access to
> >    task_struct.comm[] is a bit racy, so export the official accessor.
> > 
> 
> Maybe lirc should be submitted to staging/ before we go exporting
> symbols for out of tree things... ;-)

y:/usr/src/linux-2.6.29-rc2> grep -r 'current->comm' drivers | wc -l
77

:(
