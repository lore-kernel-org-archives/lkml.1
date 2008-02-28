Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbYB1Okh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbYB1Okh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 09:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYB1Ok3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 09:40:29 -0500
Received: from sandeen.net ([209.173.210.139]:22188 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbYB1Ok2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 09:40:28 -0500
Message-ID: <47C6C7DB.8070706@sandeen.net>
Date: Thu, 28 Feb 2008 08:40:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Gaudenz Steinlin <gaudenz@soziologie.ch>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Christoph Hellwig <hch@lst.de>,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [xfs-masters] Re: filesystem corruption on xfs after	2.6.25-rc1
 (bisected, powerpc related?)
References: <20080225112310.GA5516@soziologie.ch>	 <200802260052.57875.rjw@sisk.pl> <20080225235703.GA17530@lst.de>	 <200802260113.57875.rjw@sisk.pl>  <20080226114419.GA5353@soziologie.ch> <1204049492.13162.265.camel@johannes.berg>
In-Reply-To: <1204049492.13162.265.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
>> I debuged this a bit further by testing the 4 changed functions
>> individually. The problem only occurs with the new version of
>> xfs_lowbit64. 
...

> You really need to keep xfs_lowbit64 defined as it was before, or, maybe
> even better, define ffs64 in parallel to fls64.

Yep, I agree.

-Eric
