Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbXJVAP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbXJVAP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 20:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbXJVAPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 20:15:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56083 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750938AbXJVAPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 20:15:49 -0400
Date: Mon, 22 Oct 2007 10:15:15 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: [RFC][PATCH] block: Isolate the buffer cache in it's own mappings.
Message-ID: <20071022001515.GW995458@sgi.com>
References: <200710151028.34407.borntraeger@de.ibm.com> <20071017213216.b2d0c4bd.akpm@linux-foundation.org> <m11wbqg5he.fsf@ebiederm.dsl.xmission.com> <200710211424.46650.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710211424.46650.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 02:24:46PM +1000, Nick Piggin wrote:
> On Saturday 20 October 2007 07:27, Eric W. Biederman wrote:
> > Currently only 
> > metadata is more or less in sync with the contents of /dev/hda1.
> 
> It either is or it isn't, right? And it is, isn't it? (at least
> for the common filesystems).

It is not true for XFS - it's metadata is not in sync with /dev/<block>
at all as all the cached metadata is kept in a different address space
to the raw block device.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
