Return-Path: <linux-kernel-owner+w=401wt.eu-S1762534AbXJMTuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762534AbXJMTuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXJMTuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:50:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34427 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbXJMTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:49:59 -0400
Date: Sat, 13 Oct 2007 12:44:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jgarzik@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-git3 jfs/bio bug
In-Reply-To: <1192298280.6166.21.camel@norville.austin.ibm.com>
Message-ID: <alpine.LFD.0.999.0710131112380.6887@woody.linux-foundation.org>
References: <4710FFA3.5080309@oracle.com>
 <1192298280.6166.21.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 13 Oct 2007, Dave Kleikamp wrote:
> 
> commit 6712ecf8f648118c3363c142196418f89a510b90 removed some "return 0;"
> statements, rather than changing them to null returns.

Not commit 6712ecf8f648118c3363c142196418f89a510b90. It was the later 
e30408b2a99cb7b8bf529c7dc2328a19d71894cf commit by Jeff that removed the 
returns.

Tssk, tssk.

		Linus
