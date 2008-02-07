Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbYBGCn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbYBGCn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 21:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758856AbYBGCnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 21:43:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbYBGCnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 21:43:49 -0500
Date: Wed, 6 Feb 2008 18:43:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Cc: torvalds@linux-foundation.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] v9fs patches for merge window
Message-Id: <20080206184353.92ea8771.akpm@linux-foundation.org>
In-Reply-To: <a4e6962a0802061739v6280c3acw1a7da77991037824@mail.gmail.com>
References: <a4e6962a0802061739v6280c3acw1a7da77991037824@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 19:39:26 -0600 "Eric Van Hensbergen" <ericvh@gmail.com> wrote:

Could you please cc me on pull requests?  I need to pay more attention to
them.  Thanks.

> Andrew Morton (1):
>       9p: fix p9_printfcall export

Really this should have been folded into the patch which it fixes.  We get
a cleaner history that way, and it protects git-bisectability.

Yes, it can mean that people lose credit points.  I make that up by adding
a little note in the signoffs in the form

[foo@bar.com: <whatever [s]he did>]


box:/usr/src/git26> git-log | grep ' \[akpm' | wc -l
707

That's 707 brownie points I lost, but we really didn't want all that stuff
in the permanent record.
