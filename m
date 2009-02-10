Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbZBJV0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbZBJV0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbZBJV0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:26:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755647AbZBJV0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:26:31 -0500
Date: Tue, 10 Feb 2009 13:25:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dean Nelson <dcn@sgi.com>
Cc: tony.luck@intel.com, mingo@elte.hu, linux-ia64@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SGI IA64 UV: fix ia64 build error in the linux-next
 tree
Message-Id: <20090210132555.be1c1462.akpm@linux-foundation.org>
In-Reply-To: <20090209162520.GA4882@sgi.com>
References: <20090209162520.GA4882@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 10:25:20 -0600
Dean Nelson <dcn@sgi.com> wrote:

> Fix the ia64 build error that occurs in the linux-next tree by introducing
> an ia64 version of uv.h.  Additionally, clean up the usage of is_uv_system().

Would I be correct in believing that this repairs (and should be folded
into)

  commit 5b221278d61e3907a5e4104a844b63bc8bb3d43a
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Wed Jan 21 11:30:07 2009 +0100

      x86: uv cleanup, build fix #2

?

(it looks like 5b221278d61e3907a5e4104a844b63bc8bb3d43a should be
folded into something else, too.  What hath we wrought?)

