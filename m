Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZJYM5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZJYM5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 08:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZJYM5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 08:57:09 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:43194 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752158AbZJYM5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 08:57:07 -0400
X-Sender-Authentication: net64
Date: Sun, 25 Oct 2009 13:57:06 +0100
From: Stephan von Krawczynski <skraw@ithnet.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/5] page allocator: Do not allow interrupts to use
 ALLOC_HARDER
Message-Id: <20091025135706.8c3d24a7.skraw@ithnet.com>
In-Reply-To: <20091022163752.GU11778@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
	<1256221356-26049-3-git-send-email-mel@csn.ul.ie>
	<20091022183303.2448942d.skraw@ithnet.com>
	<20091022163752.GU11778@csn.ul.ie>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 17:37:52 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> In this case, it's ok. It's just a harmless heads-up that the kernel
> looks slightly different than expected. I posted a 2.6.31.4 version of
> the two patches that cause real problems.

After around 12 hours of runtime with patch 1/5 and 2/5 on 2.6.31.4 I can see
no page allocation failure messages so far. I'll keep you informed.

[Update]
After 2 days I still see no failure messages. 
[/update]

-- 
Regards,
Stephan
