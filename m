Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbXHBAnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbXHBAnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 20:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXHBAnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 20:43:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54287 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbXHBAnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 20:43:22 -0400
Date: Thu, 2 Aug 2007 09:44:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] 2.6.23-rc1-mm1 - fix missing numa_zonelist_order sysctl
Message-Id: <20070802094445.6495e25d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1185994972.5059.91.camel@localhost>
References: <1185994972.5059.91.camel@localhost>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 15:02:51 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> [But, maybe reordering the zonelists is not such a good idea
> when ZONE_MOVABLE is populated?]
> 

It's case-by-case I think. In zone order with ZONE_MOVABLE case,
user's page cache will not use ZONE_NORMAL until ZONE_MOVABLE in all node
is exhausted. This is an expected behavior, I think.

I think the real problem is the scheme for "How to set zone movable size to
appropriate value for the system". This needs more study and documentation.
(but maybe depends on system configuration to some extent.)

Thanks,
-Kame

