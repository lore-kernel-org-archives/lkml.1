Return-Path: <linux-kernel-owner+w=401wt.eu-S1751287AbZLOFbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbZLOFbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZLOFbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:31:14 -0500
Received: from lists.laptop.org ([18.85.2.145]:41142 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751123AbZLOFbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:31:13 -0500
Date: Tue, 15 Dec 2009 00:33:08 -0500
From: Michael Stone <michael@laptop.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: setrlimit(RLIMIT_NETWORK) vs. prctl(???)
Message-ID: <20091215053307.GA6837@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a36005b50912122120n4656b97bx6a6d862a57671e6d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On Sat, Dec 12, 2009 at 21:09, Michael Stone <michael@laptop.org> wrote:
>> That being said, I'm not wedded to the decision. Could you give me some
>> more specific examples of the kinds of changes in low-level userspace code
>> that you're worried about?
> 
> As summarized in the paraphrased comment, it's a pain to deal with
> rlimit extensions.  It's easy enough to do all this using prctl() with
> the same semantics and without forcing any other code to be modified.
> I let others more competent to judge the usefulness.  But using rlimit
> as the interface is just plain wrong.

I still like the rlimit-based interface because I think it gives good intuition
about how to use the facility and about how it ought to be exposed to high-level
parts of userland but it certainly can't hurt to cook up a version based on
prctl() so that we can make a fair comparison of the two. 

I'll see what I can come up with.

Regards,

Michael
