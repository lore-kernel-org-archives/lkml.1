Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZFHWeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZFHWeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZFHWeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:34:06 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:24025 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbZFHWeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:34:03 -0400
X-IronPort-AV: E=Sophos;i="4.41,326,1241395200"; 
   d="scan'208";a="173814023"
Date: Mon, 8 Jun 2009 15:34:06 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 3/7] initdev:kernel:Await console discovery, v6
Message-ID: <20090608223406.GD22222@cuplxvomd02.corp.sa.net>
References: <20090606023407.GA5695@cuplxvomd02.corp.sa.net> <4A2A2EED.3060506@s5r6.in-berlin.de> <20090608221344.GB22222@cuplxvomd02.corp.sa.net> <4A2D90EB.4070005@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2D90EB.4070005@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 12:30:03AM +0200, Stefan Richter wrote:
> David VomLehn wrote:
>> On Sat, Jun 06, 2009 at 04:55:09AM -0400, Stefan Richter wrote:
>>> David VomLehn wrote:
> ...
>>>> v3.2	Use only a single new command line parameter by adding the possible
>>>> 	value "forever".  Add message specifying the parameter to modify to
>>>> 	increase the delay for console initialization
>>>> v3.1	Correct the abbreviation for milliseconds in
>>>> 	Documentation/kernel-parameters.txt to be "ms", not "mS". Thanks to
> ...
>>>> ---
>>>>  drivers/accessibility/braille/braille_console.c |    2 +
>>>>  kernel/printk.c                                 |   29 ++++++++++++++++++++++-
>>>>  2 files changed, 30 insertions(+), 1 deletions(-)
>>> Is this diff complete?
>>
>> To the best of my knowledge, yes, it is complete. What makes it look as though
>> it might not be?
>
> The history notes.
> kernel-parameters.txt, new command line parameter...

Now I understand--you haven't been following this in detail, and there is
no reason why you should have. The history reflects the fact that the
original approach changed completely once Alan Stern let me know that we
really could tell when we have discovered all attached USB devices. It's
still trying to solve the same problem, however, so I kept the history
for continuity.

> Stefan Richter
