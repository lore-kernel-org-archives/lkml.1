Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXGERst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXGERst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759099AbXGERsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:48:42 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:35855 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387AbXGERsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:48:41 -0400
Message-ID: <468D2EF1.7050908@nortel.com>
Date: Thu, 05 Jul 2007 11:48:33 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Clemens Koller <clemens.koller@anagramm.de>
CC: Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <468AA364.2010000@nortel.com> <468AB976.2010806@redhat.com> <200707041056.53992.u.luckas@road.de> <20070704165313.GC4306@sequoia.sous-sol.org> <468CFCA1.3080104@anagramm.de>
In-Reply-To: <468CFCA1.3080104@anagramm.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jul 2007 17:48:36.0661 (UTC) FILETIME=[B69DCE50:01C7BF2C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Koller wrote:

> Okay, we all survived Y2K and this little glitch. Puh! ;-)
> Can you please explain in which configuration this problem got triggered.

As far as I can tell many kernel versions contained the source code bug. 
  (I'd like some more information on exactly what the problem was if 
anyone cares to share..the proposed patch didn't give much in the way of 
specifics.)

However, in order to trigger the problem you also need to have NTP 
servers that were erroneously broadcasting the addition of a leap second.

So most people didn't see the issue because there wasn't supposed to be 
a leap second added this year...but they would have seen it the next 
time a leap second was added.

Chris
