Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbZH1QRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbZH1QRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZH1QRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:17:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZH1QRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:17:44 -0400
Date: Fri, 28 Aug 2009 12:17:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jamie Lokier <jamie@shareable.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090828161745.GA8755@infradead.org>
References: <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <4A98008B.6050503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A98008B.6050503@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 09:06:35AM -0700, Ulrich Drepper wrote:
> On 08/28/2009 08:46 AM, Christoph Hellwig wrote:
>>   - given that our current O_SYNC really is and always has been actuall
>>     Posix O_DSYNC
>
> If this is true, then this proposal would work, yes.

I'll put it on my todo list.  While reading through the Posix specs
I came up with some questions that you might be able to answer:

 - O_RSYNC basically means we need to commit atime updates before a
   read returns, right?  It would be easy to implement 
   it in a slightly suboptimal fashion, but is there any point?

