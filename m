Return-Path: <linux-kernel-owner+w=401wt.eu-S1759713AbZDTWar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713AbZDTWar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbZDTW3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:29:52 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:25799 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532AbZDTW3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:29:49 -0400
X-IronPort-AV: E=Sophos;i="4.40,219,1238976000"; 
   d="scan'208";a="174269749"
Date: Mon, 20 Apr 2009 15:29:48 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [Patch] Wait for console to become available, ver 3
Message-ID: <20090420222948.GA11068@cuplxvomd02.corp.sa.net>
References: <20090420143010.697c7380.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0904201744410.6832-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904201744410.6832-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Personally, I'm in favor of adding a boot parameter.  Things could be 
> simplified slightly by treating a negative value (or a missing value) 
> as indicating an infinite timeout; then only one new parameter would be 
> needed instead of two.

I'm allergic to the idea of a user interface using negative one to mean
infinity. It's an bizzare idea that makes sense only to programming
wankers. Such as ourselves. Having a missing value mean infinitity is a
not whole lot better.

I do agree with the idea of adding one boot parameter rather than two. How
about keeping the consoledelay parameter, but allow it to either take a
string, such as "forever", or an integer, which is the number of milliseconds
to delay?  I think that will make sense to a lot more people.

Note that, as far as the implementation goes, using a -1 to mean an infinite
wait may very well make sense. I just don't think it makes sense where decent
people can see it.
--
David VomLehn
