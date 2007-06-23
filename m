Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbXFWIKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbXFWIKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 04:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbXFWIKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 04:10:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38120 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbXFWIJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 04:09:59 -0400
Date: Sat, 23 Jun 2007 09:09:53 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Smith <dsmith@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/10] Allow userspace applications to use marker.h to parse the markers section in the kernel binary.
Message-ID: <20070623080953.GA29241@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Smith <dsmith@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070510015555.973107048@polymtl.ca> <20070510020915.900170085@polymtl.ca> <20070510065137.GA7943@infradead.org> <46439941.4010909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46439941.4010909@redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 05:14:25PM -0500, David Smith wrote:
> Christoph Hellwig wrote:
> >NACK.  This shouldn't be includedable from userspace and systemtap people
> >should stop doing crap like that but use kernel infrastructure everyone
> >else uses including runtime kernel code instead of stuffin all kinds of
> >crap into their broken translator.
> 
> Christoph,
> 
> I was using the above information to parse all the available markers in 
> a kernel, but I believe I've found a way where I don't need the marker.h 
> header, so I'm OK with your NACK.
> 
> Out of curiosity, what is the kernel infrastructure you believe I should 
> be using to get a list of all available markers in a kernel?  Note that 
> I also have a requirement to get a list of all available markers in a 
> kernel that isn't the currently running one.

None.  Modules using markers should ship with the kernel or be written
on deman and not beeing created by some unreliable parser.
