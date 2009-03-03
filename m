Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZCCF5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZCCF5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 00:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZCCF5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 00:57:10 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57525 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZCCF5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 00:57:09 -0500
Message-ID: <49ACC6B0.409@garzik.org>
Date: Tue, 03 Mar 2009 00:57:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus' tree"
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>
In-Reply-To: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> While extending the documentation for submitting Linux wireless bug
> reports [1] we note the stable series policy on patches -- that of
> having an equivalent fix already in Linus' tree. I find this
> documented in Documentation/stable_kernel_rules.txt but I'm curious if
> there is any other resource which documents this or elaborates on this
> a bit more. I often tell people about this rule or push _really_ hard
> on testing "upstream" but some people tend to not understand. I think
> that elaborating a little on this can help and will hopefully create
> more awareness around the importance of trees like Stephen's
> linux-next tree.

Just have people google for GregKH's copious messages, telling people a 
fix needs to be upstream before it goes into -stable.

Typically you make things easy by emailing stable@kernel.org with a 
commit id.

There are only two exceptions:
* fix is upstream, but needs to be modified for -stable
* fix is not needed at all in upstream, but -stable still needs it

	Jeff




