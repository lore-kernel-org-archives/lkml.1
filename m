Return-Path: <linux-kernel-owner+w=401wt.eu-S933364AbXCIEcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364AbXCIEcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933369AbXCIEcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:32:41 -0500
Received: from terminus.zytor.com ([192.83.249.54]:54104 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364AbXCIEck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:32:40 -0500
Message-ID: <45F0E309.70403@zytor.com>
Date: Thu, 08 Mar 2007 20:31:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: anton@samba.org, hch@infradead.org, arjan@infradead.org,
       zippel@linux-m68k.org, dmlb2000@gmail.com, linux-kernel@vger.kernel.org,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
References: <20070308.134825.45514445.davem@davemloft.net>	<20070309024324.GA24695@kryten>	<45F0E014.8060907@zytor.com> <20070308.202718.68040662.davem@davemloft.net>
In-Reply-To: <20070308.202718.68040662.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Thu, 08 Mar 2007 20:18:28 -0800
> 
>> Anton Blanchard wrote:
>>> The other option is to create a v3 swap format that doesnt use any
>>> PAGE_SIZE parameters.
>> The best thing to do would be to look for the magic both at PAGE_SIZE 
>> (for compatibility) and MIN_PAGE_SIZE (for sanity.)
> 
> That might work, but a large part of me says to go for v3
> and do it cleanly.

The advantage would be that it wouldn't require a v3 for platforms for 
which MIN_PAGE_SIZE == PAGE_SIZE, which accounts for a very large 
percentage of systems.

You still have to look for the darn magic in two places, so there is no 
reason for it to be different.

	-hpa
