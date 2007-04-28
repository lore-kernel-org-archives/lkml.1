Return-Path: <linux-kernel-owner+w=401wt.eu-S1161268AbXD1W2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161268AbXD1W2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161276AbXD1W2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:28:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39901 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161268AbXD1W2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:28:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4633CA7F.6010505@s5r6.in-berlin.de>
Date: Sun, 29 Apr 2007 00:28:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: random thoughts on DEPRECATED and OBSOLETE
References: <Pine.LNX.4.64.0704280925270.24691@localhost.localdomain> <46337BD2.7000701@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281320560.27098@localhost.localdomain> <4633ACE4.50004@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281635190.28274@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0704281635190.28274@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Sat, 28 Apr 2007, Stefan Richter wrote:
>> And that benefit is...? :-)
...
> if you're not convinced, there's nothing else i can think of to say
> that will persuade you.

It didn't come across this way, sorry, but I didn't ask a priori to be
persuaded, but rather because I thought your argument (at the wiki site)
could be enhanced by pointing out the concrete applications of the
facility.  When I visited the page, it only explained how the facility
works, not what the end-use is.

[...]
>> But it can be controversial whether a piece of code
>> deserves one of these labels.
> 
> in the first place, that would be *entirely* the decision of the
> maintainer, just as it is now.  but nothing says that starting to tag
> stuff has to affect you in any way.  there should be a top-level
> selection that lets you even *activate* the maturity level settings as
> part of your configuration.

(Although if a certain number of kernel components is inappropriately
labeled, the facility becomes useless of course.)

[...]
>> "maturity" is just like "depends on" with the added feature that UIs
>> are supposed to print the flag onto the screen even if the user did
>> not enable a debug mode of the UI.
>>
>> It's really nothing more.
[...]
> sure, i have no disagreement with that.  (um ... was there something
> there i was supposed to address?  it just sounded like you were
> clarifying what we were talking about.)

You said "it's not just presentational markup", I said "it is". :-)

[deprecated and obsolete exclusive?]
>> DEPRECATED = "I don't want you to build or run this if you can
>> possibly avoid it."
>>
>> OBSOLETE = "There is other stuff which does more or less the same,
>> and this here could go away in the future."
> 
> nope.  we've been down this road before, and the consensus was that
> something could be one of deprecated or obsolete, but not both.  i can
> re-post those definitions if you want, or you could read about them
> here:
> 
> http://kerneltrap.org/node/7593

I see a discussion on OBSOLETE vs. BROKEN there, which even ended in a
consensus, but I do not see an explicit discussion on OBSOLETE vs.
DEPRECATED.  The only definition of DEPRECATED I see there is yours, and
as it is worded, it is largely overlapping with the definition of
OBSOLETE (which, as it is laid down in that thread, is mostly yours too)
--- but it is not actually conflicting with it.

Note, another classification system can be found in
Documentation/ABI/README.  That one also features the category
"obsolete", but does not include a category "deprecated".  This is
beneficial because it doesn't leave room for disagreeing interpretations
like ours, nor for any overlap in the definitions like in those at the
end of the thread you referenced.
-- 
Stefan Richter
-=====-=-=== -=-- ===--
http://arcgraph.de/sr/
