Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZKTQoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZKTQoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZKTQoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:44:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:60078 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbZKTQoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:44:14 -0500
Date: Fri, 20 Nov 2009 08:45:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091120084537.6e28ddd2@infradead.org>
In-Reply-To: <20091120160526.GD20634@shareable.org>
References: <20091025225342.007138f5@infradead.org>
	<20091111020108.GA11423@localhost>
	<20091110223456.01ef355f@infradead.org>
	<4AFA6AEF.5060306@garzik.org>
	<20091111081905.270a4e55@infradead.org>
	<y0m3a4kpsiw.fsf@fche.csb>
	<4AFB4AC7.1090405@intel.com>
	<20091112072217.GA31719@elte.hu>
	<20091120104335.GB29143@infradead.org>
	<20091120064511.268cc8fd@infradead.org>
	<20091120160526.GD20634@shareable.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 16:05:26 +0000
Jamie Lokier <jamie@shareable.org> wrote:

> Arjan van de Ven wrote:
> > in my case it's not about finding the file, but finding the place in
> > the application that is doing the writing. The last pathname
> > component is more than enough for this....
> 
> So what you really need is the source file and line number in your
> application where it does the writing :-)

while you present this as a joke.... perf can more or less do this
using the backtrace infrastructure ...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
