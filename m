Return-Path: <linux-kernel-owner+w=401wt.eu-S935263AbZJOTYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935263AbZJOTYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762485AbZJOTYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:24:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39685
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757758AbZJOTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:24:06 -0400
Date: Thu, 15 Oct 2009 12:24:02 -0700 (PDT)
Message-Id: <20091015.122402.186934862.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: gregkh@suse.de, david@lang.hm, stefanr@s5r6.in-berlin.de,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: removing existing working drivers via staging
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910151942.40259.bzolnier@gmail.com>
References: <alpine.DEB.2.00.0910150936310.22169@asgard.lang.hm>
	<20091015164726.GA10125@suse.de>
	<200910151942.40259.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Thu, 15 Oct 2009 19:42:40 +0200

> On Thursday 15 October 2009 18:47:26 Greg KH wrote:
>> On Thu, Oct 15, 2009 at 09:39:51AM -0700, david@lang.hm wrote:
>> > however, what I think I saw proposed was to move drivers that need to be 
>> > 'cleaned up', to staging and then dropping them if they don't get cleaned.
>> 
>> What is "proposed" is the following:
>> 
>> 	- For drivers currently in the kernel tree, that the subsystem
>> 	  maintainer, for whatever reason, feels is obsolete / broken /
>> 	  needs major cleaning / wants to get rid of, can be submitted
>> 	  to the staging maintainer to be moved to the drivers/staging/
>> 	  directory.
> 
> This is insanity and opens a door for various forms of abuse.

Being a maintainer, period, give the person these kinds of "abusive"
powers.  The same thing that controls them already, will still control
them in this case with this new rule.  And that's public pressure and
the will of the larger developer community.
