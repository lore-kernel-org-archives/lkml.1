Return-Path: <linux-kernel-owner+w=401wt.eu-S933067AbZKDXHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbZKDXHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbZKDXHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:07:25 -0500
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:47939
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756935AbZKDXHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:07:24 -0500
Date: Thu, 5 Nov 2009 00:07:19 +0100
From: Michael Guntsche <mike@it-loops.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Page alloc problems with 2.6.32-rc kernels
Message-ID: <20091104230719.GA17756@gibson.comsick.at>
References: <20091102122010.GA5552@gibson.comsick.at>
 <200911040114.08879.elendil@planet.nl>
 <20091104071750.GA19287@gibson.comsick.at>
 <200911042314.35006.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911042314.35006.elendil@planet.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04 Nov 09 23:14, Frans Pop wrote:
> OK. Can you tell us a bit more about your setup:
> - how much RAM does the system have?
512MB 
> - what's so special about mutt in your case that it triggers these errors?
>   - do you maybe have a huge mailbox, so mutt uses a lot of memory?
>   - does starting/use mutt cause swapping when you see the errors?
Mutt is accessing a maildir directory with a several subdirectories
directly. All of them are added as mailboxes so I can jump to unread
mails. During startup and folder changing mutt is accessing all the
mailboxes.
> 
> From your first mail it does look as if you had little free memory and that 
> swap was in use.
I noticed that as well.
During the last days memory usage was not that high so maybe this
is the reason why I did not see any errors. I will continue running 
latest git and see if a get the errors again when more memory is being
used.

Kind regards,
Michael
