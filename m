Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbYF3XT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbYF3XT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 19:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYF3XTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 19:19:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbYF3XTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 19:19:22 -0400
Date: Mon, 30 Jun 2008 16:18:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linuxfoundation.org, bunk@kernel.org, dhowells@redhat.com,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MN10300: Provide __ucmpdi2() for MN10300
Message-Id: <20080630161825.294d3d2c.akpm@linux-foundation.org>
In-Reply-To: <20080613130958.26794.23426.stgit@warthog.procyon.org.uk>
References: <20080613130952.26794.26092.stgit@warthog.procyon.org.uk>
	<20080613130958.26794.23426.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 14:09:58 +0100
David Howells <dhowells@redhat.com> wrote:

> Provide __ucmpdi2() for MN10300 so that allmodconfig can be built.

Well...  x86 has this problem as well, and when it pops up we address
it by going in and looking at the codesite which is generating the call
and fixing it.  And I do mean "fixing", because it's often the case
that the caller was doing something silly and inefficient.

So are you sure that we should do this, rather than massaging the
callers?
