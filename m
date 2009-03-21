Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbZCUPB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbZCUPB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZCUPBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:01:48 -0400
Received: from rtr.ca ([76.10.145.34]:44362 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbZCUPBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:01:47 -0400
Message-ID: <49C50154.7010504@rtr.ca>
Date: Sat, 21 Mar 2009 11:01:40 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Norman Diamond <n0diamond@yahoo.co.jp>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Overagressive failing of disk reads, both LIBATA and IDE
References: <F79C774361EF45A6A68BC08F8621E406@DIAMOND8600>	 <49C30E67.4060702@rtr.ca> <1237645333.4600.9.camel@localhost.localdomain> <49C4FFFB.5000601@rtr.ca>
In-Reply-To: <49C4FFFB.5000601@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
..
> I think it could be even more clever, using a binary search or something
> on the remaining chunks, so that it takes less time to skip over a huge
> stretch of sequential bad sectors (scratch on media).  That would probably
> be best all around.
..

Heh.. pity that spinning media cannot do a "READ BACKWARDS" type of operation.

:)
