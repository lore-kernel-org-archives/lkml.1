Return-Path: <linux-kernel-owner+w=401wt.eu-S1765213AbZEAUW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765213AbZEAUW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZEAUWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:22:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46703 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbZEAUWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:22:49 -0400
Date: Fri, 1 May 2009 16:22:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josh Stone <jistone@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>,
       mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] export softirq_to_name symbol
Message-ID: <20090501202246.GA20056@infradead.org>
References: <20090501193022.GB3111@redhat.com> <20090501195015.GA31694@infradead.org> <49FB5686.8020908@redhat.com> <20090501201028.GA2084@infradead.org> <49FB58F7.8080109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FB58F7.8080109@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 01:17:59PM -0700, Josh Stone wrote:
> More precisely, it's the piece of code that copies the trace into an
> __entry pointer.  In my case, __entry has nothing to do with the ring
> buffer.

Well, it should be the ring buffer.  If you want to do something more
fancy rewrite it in proper C code and submit a patch for discussion to
lkml.

