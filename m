Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbYHNTqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbYHNTqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYHNTqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:46:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753642AbYHNTqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:46:35 -0400
Message-ID: <48A48B00.1090703@linux-foundation.org>
Date: Thu, 14 Aug 2008 14:44:00 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <48986AC6.5030406@linux-foundation.org>	 <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <48A2DD2C.3090602@linux-foundation.org>	 <2f11576a0808130714k2cd031c4nd6eea3506831cac9@mail.gmail.com>	 <48A2F030.9080301@linux-foundation.org> <2f11576a0808130805s6963e2a4mbb82ad7221cf80a2@mail.gmail.com>
In-Reply-To: <2f11576a0808130805s6963e2a4mbb82ad7221cf80a2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a NUMA system right? Then we have another mechanism that will avoid
off node memory references by allocating new slabs. Can you set the
node_defrag parameter to 0? (Noted by Adrian).


