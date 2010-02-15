Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab0BOVYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:24:17 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:37694 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab0BOVYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=s9i6jZN3l1ijVJBxw0e0IDbHyo+QPGXrO3QOylGXvYKfX2ITxVilLEa7+lcQOTtqZn
         yXTQ9OhBW118tTGK9+jUsFOrDwoe6wM+FoQWRmbnxWl+GO4OZuPgozw5lZ47Xb/4PeZm
         1ZWVsDXHvAmuLn0Uq/emWhanDC2G1/1BHy7aM=
Message-ID: <4B79BB7C.6020507@gmail.com>
Date: Mon, 15 Feb 2010 16:24:12 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 4/7] tcp: input header length, prediction, and timestamp
 bugs
References: <4B793CAA.2030902@gmail.com> <4B793E8F.30208@gmail.com> <20100215151055.GG21783@one.firstfloor.org> <4B799A86.8040303@gmail.com> <20100215191548.GH21783@one.firstfloor.org>
In-Reply-To: <20100215191548.GH21783@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Mon, Feb 15, 2010 at 02:03:34PM -0500, William Allen Simpson wrote:
>> Andi Kleen wrote:
>>> Is this a bug fix? 
>>>
>> Yes.  One of many, all inter-related.
>>
> It's useful to distingush bug fixes from cleanups from optimizations etc.
> ...

The bug fixes depend on the cleanups.
  * 1/7 has the new functions.
  * 2/7 has bug fixes that require the new functions.
  * 3/7 fixes (and optimizes) the incoming code path, so that
  * 4/7 can fix the bugs.
  * 5/7 is needed to test the code from part 1.
  * 6/7 is the cleanup of parsing (also fixes some bugs introduced by
    davem's patch in December), so that
  * 7/7 can fix the bugs.

I originally tried submitting these as separate individual pairs of
patches (in November, December, January), but nobody paid any attention.
