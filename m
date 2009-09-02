Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZIBNcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZIBNcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZIBNcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:32:10 -0400
Received: from ns1.ata-over-ethernet.org ([12.51.113.4]:51447 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752054AbZIBNcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:32:10 -0400
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 2 Sep 2009 09:31:49 -0400
To: bonbons@linux-vserver.org, ecashin@coraid.com, apw@canonical.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue correctly
Message-ID: <515b4651c5aa3f5bc550b26fe708f65d@coraid.com>
In-Reply-To: <20090901223128.4bf1bf53@neptune.home>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
	<9ab0e087296715d764071d4d39542985@coraid.com>
	<20090829154305.723fd86c@neptune.home>
	<6309cc7d77486e24aca5130ec5802dfb@coraid.com>
	<20090901223128.4bf1bf53@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Sep  1 16:31:58 EDT 2009, bonbons@linux-vserver.org wrote:
> On Tue, 01 September 2009 Ed Cashin <ecashin@coraid.com> wrote:
...
> > Thanks much for doing that.  It makes sense that this change would
> > have caused it to suddenly matter whether the unused queue is
> > initialized.
> > 
> > The patch looks fine to me.
> 
> Would it make sense to fine-tune the values reported by sys-fs in the
> queue details so they match with the AoE device (as a separate
> enhancement patch)?
> 
> Sure the queue itself won't use them, but some user-space tools might
> be interested in this data.
> 
> I've not checked what information is provided by AoE protocol or can
> be deducted from interface MTU.

The AoE protocol does allow a storage target to say, "I can handle
this certain number of sectors in a single read or write command." But
the user space tools cannot really benefit from that information,
since they can send larger read/write operations with no loss of
efficiency.

So I suspect that it would not make much sense, but if you decide to
look into it further, see whether you can identify an extant user
space tool that benefits from the information.

-- 
  Ed Cashin
  http://noserose.net/e/
