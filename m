Return-Path: <linux-kernel-owner+w=401wt.eu-S965065AbZLHAIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065AbZLHAIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935755AbZLHAI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:08:27 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:33592 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935730AbZLHAIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:08:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=s/JgxY3wIZOt5ULVdF/Pt6u43MH3ex30rWMx3FIczPevyX7AAAoy9m1Y36UcWgYbkC
         bOm/Qf/LjqZS5qoc0efgkFuhlThXgK6/TPIWtVdVE+dfZRPw7+GONpaWN9EH9MJofzBz
         t0WTtWezLWBINs8hujKXN/cZp903P8qkq8vyE=
Message-ID: <4B1D98FA.80809@gmail.com>
Date: Mon, 07 Dec 2009 19:08:26 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: Add warning about leading	contination
 tests
References: <1260035884.11126.58.camel@Joe-Laptop.home> <20091207220501.GF32454@fieldses.org>
In-Reply-To: <20091207220501.GF32454@fieldses.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> Where does this preference come from?
> 
David Miller -- in response to a patch of mine that used:
  - trailing && on existing lines that already had trailing &&, and
  - leading && on existing lines that already had leading &&, and
  - leading && on new code.

He decided he wants "consistency", existing code be damned.


> In
> 
> 	excessivelylongcondition
> 	&& anotherreallylongcondition
> 	&& yetanotherunbelievablylongcondition
> 	&& yetanotherwellyougettheidea
> 
> I want to be able to keep the &&'s all justified.
> 
Agree with you and Jean Delvare and thousands of other developers.


> Or look for well-typeset math or CS texts and try to find any that leave
> operators dangling on the right.
> 
Agreed.


> I don't really care much about this particular point, but: the
> checkpatch output is already getting too verbose to be useful, without
> adding advice that's actually the opposite of what I'd normally want to
> do....
> 
Yes, you are agreeing with a point Jean raised here, too.

Count me as opposed to this patch.

When I first looked at CodingStyle back in August, one thing that appealed
to me was the laid-back simpler style -- very few, very clear rules.

I'd prefer an addition to CodingStyle clarifying that we should not argue
about this minutiae.
