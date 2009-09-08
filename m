Return-Path: <linux-kernel-owner+w=401wt.eu-S1751178AbZIHO7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbZIHO7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbZIHO7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:59:09 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:34906 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZIHO7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:59:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dyOrNoXTTD16D/ocIaoAE93w2pKFJtJ+R2P1JUuZrQ4WIMPLSV7DLgNskHJOF7MOcP
         lbcMdpQhfzM/6/Zt5RA7Zc0eB5BSzch0h5/xHINhqL4qnJEG22Z2WYEl2zJUEAVi9Qj9
         sO8o1ZchHIqmZP+1eln2W2q+EOa+n21MW2sCo=
Message-ID: <4AA67139.80301@lwfinger.net>
Date: Tue, 08 Sep 2009 09:59:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org
Subject: Re: iwlagn: order 2 page allocation failures
References: <200909060941.01810.elendil@planet.nl> <84144f020909060114s74de2d2y850745dd82ece753@mail.gmail.com> <200909061028.48442.elendil@planet.nl> <1252226116.11274.10.camel@penberg-laptop> <20090908105415.GD28127@csn.ul.ie> <84144f020909080411n4e010308qa153039bee1b8336@mail.gmail.com> <20090908141701.GB2617@tuxdriver.com>
In-Reply-To: <20090908141701.GB2617@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> On Tue, Sep 08, 2009 at 02:11:35PM +0300, Pekka Enberg wrote:
>> On Tue, Sep 8, 2009 at 1:54 PM, Mel Gorman<mel@csn.ul.ie> wrote:
>>> My feeling is also that a number of these page allocation failures have
>>> been related to wireless drivers. Is that accurate? If so, have there
>>> been changes made to the wireless stack in this cycle that would have
>>> increased the order of pages allocated?
>> That's my general feeling as well. We have linux-wireless CC'd so
>> maybe this rings a bell for them.
> 
> AFAIK, this is only the second separate report.  The other related
> to ipw2200, which actually shares no code with the iwlagn driver and
> is not based on the mac80211 stack.

A previous issue concerned the interaction between wireless and SLUB
debugging that caused O(0) allocations to get bumped to O(1), but that
was not relevant to this case either. I'm not aware of any other page
allocation problems with wireless.

Larry
