Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0BALuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 06:50:16 -0500
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:34883 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054Ab0BALuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 06:50:14 -0500
X-Greylist: delayed 3382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2010 06:50:14 EST
Message-ID: <4B66B2BB.9050909@farnz.org.uk>
Date: Mon, 01 Feb 2010 10:53:47 +0000
From: Simon Farnsworth <simon@farnz.org.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alexander Clouter <alex@digriz.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
References: <1264597747.3607.29.camel@wall-e> <87hbq6dy2k.fsf@basil.nowhere.org> <17r837-m29.ln1@chipmunk.wormnet.eu>
In-Reply-To: <17r837-m29.ln1@chipmunk.wormnet.eu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Clouter wrote:
> Andi Kleen <andi@firstfloor.org> wrote:
>>> The time of 80 characters punch card and terminals are over, so i would
>>> be a good thing to set the line length limit to 120. Every display today
>>> should be able handle this. 
>>>   
>>> Signed-off-by: Stefani Seibold <stefani@seibold.net>
>> Full Ack!
>>
> NACK Attack!
> 
> There is a reason Knuth only put so many words on a line with TeX.
> 
If you're going to cite Knuth as a reason for the 80 character per line
limit, you should understand the difference between ribbon length and
line length.

While there are good reasons to constrain the number of characters in a
ribbon, and to prohibit too much of a shift in indentation between two
neighbouring lines, there's no particularly strong readability reason to
limit a line to 80 characters.

Thus, assuming that maintainers read the patches they're sent, and apply
a bit of common sense (insisting on sensibly sized ribbons, and getting
grouchy about deep indentation), an 80 character line length limit isn't
needed.

-- 
Simon
