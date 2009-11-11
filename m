Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZKKGda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZKKGda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZKKGd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:33:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:56652 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZKKGd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:33:28 -0500
Date: Tue, 10 Nov 2009 22:34:56 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091110223456.01ef355f@infradead.org>
In-Reply-To: <20091111020108.GA11423@localhost>
References: <20091025225342.007138f5@infradead.org>
	<20091111020108.GA11423@localhost>
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

On Wed, 11 Nov 2009 10:01:08 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Hi Arjan,
> 
> > +	TP_printk("task=%i (%s) file=%s dev=%s",
> > +		__entry->pid, __entry->comm, __entry->file,
> > __entry->dev)
> 
> Maybe this is enough for POWERTOP, however for general use, the dirty
> type(data/metadata) and inode number may be valuable to some users?

what can a user do with an inode number????

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
