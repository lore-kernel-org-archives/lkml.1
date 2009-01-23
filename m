Return-Path: <linux-kernel-owner+w=401wt.eu-S1764209AbZAWGbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764209AbZAWGbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761673AbZAWGVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:21:25 -0500
Received: from relay3.sgi.com ([192.48.171.31]:47735 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762112AbZAWGVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:21:24 -0500
In-Reply-To: <20090123000617.GB4970@infradead.org>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice> <20090121035703.GH10158@disturbed> <200901211503.07308.nickpiggin@yahoo.com.au> <20090122043747.GU10158@disturbed> <20090122061158.GA31104@infradead.org> <20090123000203.GC32390@disturbed> <20090123000617.GB4970@infradead.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <287917FE-424B-4DAD-B957-6B37C171E888@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Sesterhenn <snakebyte@gmx.de>,
       Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, npiggin@yahoo.com.au, xfs@oss.sgi.com
Content-Transfer-Encoding: 7bit
From: Felix Blyakher <felixb@sgi.com>
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Date: Fri, 23 Jan 2009 00:20:44 -0600
To: Christoph Hellwig <hch@infradead.org>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 22, 2009, at 6:06 PM, Christoph Hellwig wrote:

>> [XFS] Check buffer lengths in log recovery
>>
>> Before trying to obtain, read or write a buffer,
>> check that the buffer length is actually valid. If
>> it is not valid, then something read in the recovery
>> process has been corrupted and we should abort
>> recovery.
>>
>> Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
>> Signed-off-by: Dave Chinner <david@fromorbit.com>
>> Tested-by: Eric Sesterhenn <snakebyte@gmx.de>
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>


