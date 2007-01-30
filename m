Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXA3OM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXA3OM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965458AbXA3OM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:12:57 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45867 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965456AbXA3OM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:12:57 -0500
Message-ID: <45BF523D.9060002@pobox.com>
Date: Tue, 30 Jan 2007 09:12:13 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jgarzik@pobox.com>,
       Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_platform: fallout from set_mode() change
References: <E1HBsxd-0002NU-Uz@ZenIV.linux.org.uk> <45BF49DC.3060206@pobox.com> <20070130140518.GB26984@linux-sh.org>
In-Reply-To: <20070130140518.GB26984@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Tue, Jan 30, 2007 at 08:36:28AM -0500, Jeff Garzik wrote:
>> Al Viro wrote:
>>> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>> This is already in the queue via Andrew, who caught the same problem.
>>
>> Sometimes it seems like you and Andrew are the only people to build on 
>> non-x86 these days...
>>
> This is the first I've heard of this or the changes that caused this,
> while I do build current git on a pretty much daily basis, -mm doesn't
> get nearly as much testing.
> 
> There are many people who build on non-x86 every day, there are rather
> less people who have the bandwidth for -mm as well as current git or
> for tracking down changes that haven't made it upstream to make sure
> everything plays nice.
> 
> If you want immediate action, I suggest you CC the authors of the drivers
> when there's changes they should be made aware of, rather than deferring
> to hand-waving generalizations about how no one does any testing after
> the fact.

The change in question is in the current -git.  But my comment was 
largely self-critical, since /I/ applied the patch in question that 
broke on non-x86.

	Jeff



