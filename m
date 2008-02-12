Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYBLFJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYBLFJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYBLFJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:09:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40838 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYBLFJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:09:00 -0500
Date: Mon, 11 Feb 2008 21:07:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm <linux-mm@kvack.org>, Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH for 2.6.24][regression fix] Mempolicy: silently restrict
 nodemask to allowed nodes V3
Message-Id: <20080211210724.eec5421d.akpm@linux-foundation.org>
In-Reply-To: <20080212122637.29B7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <alpine.LFD.1.00.0802092340400.2896@woody.linux-foundation.org>
	<1202748459.5014.50.camel@localhost>
	<20080212122637.29B7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 13:30:22 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Andrew
> 
> # this is second post of the same patch.
> 
> this is backport from -mm to mainline.
> original patch is http://marc.info/?l=linux-kernel&m=120250000001182&w=2
> 
> my change is only line number change and remove extra space.

This is identical to what I have now.

> please ack.

As it's now post -rc1 and not a 100% obvious thing, I tend to hang onto
such patches for a week or so before sending up to Linus

Should this be backported to 2.6.24.x?  If so, the reasons for such a
relatively stern step should be spelled out in the changelog for the
-stable maintiners to evaluate.

Thanks.
