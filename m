Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbZJXGs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbZJXGs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 02:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZJXGsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 02:48:55 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56654 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbZJXGsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 02:48:54 -0400
Message-ID: <4AE2A333.6060307@cs.helsinki.fi>
Date: Sat, 24 Oct 2009 09:48:19 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
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
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       " \" <linux-mm@kvack.org>, akpm@linux-foundation.org, torvalds@linux-foundation.org"@cs.helsinki.fi
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC
  failures V2
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <84144f020910220747nba30d8bkc83c2569da79bd7c@mail.gmail.com> <alpine.DEB.1.10.0910232151380.2001@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0910232151380.2001@V090114053VZO-1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009, Pekka Enberg wrote:
>> These are pretty obvious bug fixes and should go to linux-next ASAP IMHO.

Christoph Lameter wrote:
> Bug fixes go into main not linux-next. Lets make sure these fixes really
> work and then merge.

Regardless, patches 1-2 and should _really_ go to Linus' tree (and 
eventually -stable) while we figure out the rest of the problems. They 
fix obvious regressions in the code paths and we have reports from 
people that they help. Yes, they don't fix everything for everyone but 
we there's no upside in holding back fixes that are simple one line 
fixes to regressions.

		Pekka
