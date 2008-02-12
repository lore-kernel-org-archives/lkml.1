Return-Path: <linux-kernel-owner+w=401wt.eu-S1762535AbYBLNT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762535AbYBLNT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbYBLNTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:19:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47816 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbYBLNTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:19:50 -0500
Date: Tue, 12 Feb 2008 22:18:57 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for 2.6.24][regression fix] Mempolicy: silently restrict nodemask to allowed nodes V3
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm <linux-mm@kvack.org>, Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <20080211210724.eec5421d.akpm@linux-foundation.org>
References: <20080212122637.29B7.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080211210724.eec5421d.akpm@linux-foundation.org>
Message-Id: <20080212220916.B1EC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > please ack.
> 
> As it's now post -rc1 and not a 100% obvious thing, I tend to hang onto
> such patches for a week or so before sending up to Linus

Thanks, really thanks.


> Should this be backported to 2.6.24.x?  If so, the reasons for such a
> relatively stern step should be spelled out in the changelog for the
> -stable maintiners to evaluate.

Oh,
you think below reason is not enough, really?

1. it is regression.
2. it is very easy reprodusable on memoryless node machine.


if so, i back down on my backport reclaim.
I don't hope increase your headache ;-)

thanks.

-kosaki


