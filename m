Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbXEJGvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbXEJGvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbXEJGvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:51:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58401 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbXEJGvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:51:45 -0400
Date: Thu, 10 May 2007 07:51:37 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       David Smith <dsmith@redhat.com>
Subject: Re: [patch 03/10] Allow userspace applications to use marker.h to parse the markers section in the kernel binary.
Message-ID: <20070510065137.GA7943@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	David Smith <dsmith@redhat.com>
References: <20070510015555.973107048@polymtl.ca> <20070510020915.900170085@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510020915.900170085@polymtl.ca>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:55:58PM -0400, Mathieu Desnoyers wrote:
> One of the things I'm starting to work on is adding support for your
> kernel markers to systemtap.  I know the marker stuff is still in a bit
> of flux because you are trying to meet the (sometimes conflicting)
> requirements of the people on lkml.
> 
> One of the things systemtap is going to need is to be able to parse the
> '__markers' section so it will be able to look up a user-specified
> marker.  For instance, if the user says 'probe kernel.mark("foo") {}',
> I've got to see if marker "foo" really exists.

NACK.  This shouldn't be includedable from userspace and systemtap people
should stop doing crap like that but use kernel infrastructure everyone
else uses including runtime kernel code instead of stuffin all kinds of
crap into their broken translator.
