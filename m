Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbXCJG70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbXCJG70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933413AbXCJG70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:59:26 -0500
Received: from holomorphy.com ([66.93.40.71]:60114 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933422AbXCJG7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:59:24 -0500
Date: Fri, 9 Mar 2007 22:59:27 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler)
Message-ID: <20070310065927.GH2986@holomorphy.com>
References: <200703091625.55361.a1426z@gawab.com> <200703092343.46276.a1426z@gawab.com> <20070310001648.GF2986@holomorphy.com> <200703100834.25136.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703100834.25136.a1426z@gawab.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>>>> This sort of concern is too subjective for me to have an opinion on it.

On Fri, Mar 09, 2007 at 11:43:46PM +0300, Al Boldi wrote:
>>> How diplomatic.

William Lee Irwin III wrote:
>> Impoliteness doesn't accomplish anything I want to do.

On Sat, Mar 10, 2007 at 08:34:25AM +0300, Al Boldi wrote:
> Fair enough.  But being honest about it, without flaming, may be more 
> constructive.

There was no flamage. It is literally true.


William Lee Irwin III wrote:
>> I'm more of a cooperative than competitive person, not to say that
>> flies well in Linux. There are more productive uses of time than having
>> everyone NIH'ing everyone else's code. If the result isn't so great,
>> I'd rather send them code or talk them about what needs to be done.

On Sat, Mar 10, 2007 at 08:34:25AM +0300, Al Boldi wrote:
> Ok, let's call it cooperative competitiveness.  You know, the kind of 
> competitiveness that drives improvements that helps everybody

This trips over ideological issues best not discussed on lkml.


William Lee Irwin III wrote:
>> The extant versions of it fall well short of Linus' challenge as well
>> as my original goals for it.

On Sat, Mar 10, 2007 at 08:34:25AM +0300, Al Boldi wrote:
> Do you mean Peter Williams' PlugSched-6.5-for-2.6.20?

You'd be well-served by talking to Peter Williams sometime. He's a
knowledgable individual. I should also mention that Con Kolivas did
significant amounts of work to get the early codebase he inherited
from me working before things were handed off to Peter Williams.


William Lee Irwin III wrote:
>> A useful exercise may also be enumerating
>> your expectations and having those who actually work with the code
>> describe how well those are actually met.

On Sat, Mar 10, 2007 at 08:34:25AM +0300, Al Boldi wrote:
> A runtime configurable framework that allows for dynamically extensible 
> schedulers.  PlugSched seems to be a good start.

Last I checked there were limits to runtime configurability centering
around only supporting a compiled-in set of scheduling drivers, unless
Peter's taken it the rest of the way without my noticing. It's unclear
what you have in mind in terms of dynamic extensibility. My only guess
would be pluggable scheduling policy/class support for individual
schedulers in addition to plugging the individual schedulers, except
I'm rather certain that Williams' code doesn't do anything with modules.


-- wli
