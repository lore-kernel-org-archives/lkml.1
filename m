Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXJHSCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXJHSCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbXJHSCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:02:40 -0400
Received: from gw.goop.org ([64.81.55.164]:44935 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbXJHSCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:02:39 -0400
Message-ID: <470A708D.4080905@goop.org>
Date: Mon, 08 Oct 2007 11:01:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
References: <25555.1191864285@lwn.net> <20071008173706.GA12026@uranus.ravnborg.org> <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>> Acked-by:
>> Tested-by:
>>     
>
> * Used by random people to express their (dis)like/experience with the 
> patch.
>   

Tested-by is more valuable than acked-by, because its empirical. 
Acked-by generally means "I don't generally object to the idea of the
patch, but may not have read beyond the changelog".  Tested-by implies
"I did something that exercised the patch, and it didn't explode" -
that's on par with an actual review (ideally all patches would be both
tested and reviewed).

>> Reviewed-by:
>>     
>
> * I am maintaner or an 'important' person and have had a
>   look at it in depth
>   

Hm.  We have a tension here:

    * there aren't enough reviewers
    * some reviews are more useful than others

While a review by a trustworthy person is invaluable, we don't want to
discourage people from reviewing.  A new reviewer's review may not be
terribly useful, but a meta-review may help improve it.  Or it could be
a great review.

I guess I'm proposing that we also need to expand the reviewer base, and
to do so we need some kind of reviewer-mentoring or metareview process. 
Of course that could just be an extra burden on the existing (small)
trusted reviewer base, but the hope is that over time the reviewer pool
size grows enough to make the effort worthwhile...


>> Cc:
>>     
>
> * Used by original submitter to denote additional maintainers it goes to
> * Parties who should be Cced when an a posteriori question comes up
>   

Well, any interested parties, really.  I use it for original bug
reporters, people who followed up on the report, people who have patches
in a nearby area, people who are known to be interested in the affected
subsystem, people who have reviewed previous versions of the patch, etc...

    J
