Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbXJ3XGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbXJ3XGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758523AbXJ3XGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:06:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54591 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758494AbXJ3XGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:06:35 -0400
Date: Tue, 30 Oct 2007 16:04:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] 0/4 fs/ioctl.c coding style, function
 renaming/factoring
Message-Id: <20071030160442.e51e2b45.akpm@linux-foundation.org>
In-Reply-To: <11937731993134-git-send-email-ezk@cs.sunysb.edu>
References: <11937731993134-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 15:39:55 -0400
Erez Zadok <ezk@cs.sunysb.edu> wrote:

> This series of 4 proposed patches (take 3) changes fs/ioctl.c and Unionfs as
> follows.

The problem is of course that you need these in your tree for ongoing
development, but 2.6.25 is months away.  They look OK to me so I suggest
that you go ahead and commit them to your git tree and I'll drop them
again.  Please resend them for merging in the 2.6.25-rc1 merge window.


unionfs has been hanging around for a long time now and we should work
towards getting it into 2.6.25 or dropped from -mm (sorry).  Right now
would be a great time to get this process underway.  

I have only a partial memory of what the sticking points were, and I have
basically zero knowledge of what was done to address them.  So could you
please, over the next few weeks:

- Send out a description of what the issues were, and how they were addressed

- If issues remain, describe their impact and possible workarounds, all
  that stuff.

- If it mostly-survives all that design-level review and consideration
  then let's go for it: get all the patches cleaned up and consolidated and
  get them emailed out for review no later than 2.6.24-rc5.

Thanks.
