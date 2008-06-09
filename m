Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbYFIAPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbYFIAPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 20:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYFIAPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 20:15:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbYFIAPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 20:15:40 -0400
Date: Sun, 8 Jun 2008 17:15:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dean Nelson <dcn@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 09/18] base xpc_rsvd_page's timestamp on jiffies
Message-Id: <20080608171537.eaf597d2.akpm@linux-foundation.org>
In-Reply-To: <20080606165216.GJ13695@sgi.com>
References: <20080606164034.GA13695@sgi.com>
	<20080606165216.GJ13695@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 11:52:16 -0500 Dean Nelson <dcn@sgi.com> wrote:

> +	unsigned long stamp;	/* time when reserved page was setup by XPC */

"time" is a rubbery concept in-kernel.  What are the units of this? 
microseconds?  jiffies?  seconds?

At the least, the covering comment should make clear what units this
variable is using.  Better would be to actually embed the units in the
variable's identifier.  Because it's awfulyl easy to make mistakes over
this, and not knowing the units makes the code harder to follow.

