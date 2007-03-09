Return-Path: <linux-kernel-owner+w=401wt.eu-S2992944AbXCIEUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992944AbXCIEUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992947AbXCIEUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:20:38 -0500
Received: from terminus.zytor.com ([192.83.249.54]:55270 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992944AbXCIEUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:20:37 -0500
Message-ID: <45F0E014.8060907@zytor.com>
Date: Thu, 08 Mar 2007 20:18:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: David Miller <davem@davemloft.net>, hch@infradead.org, arjan@infradead.org,
       zippel@linux-m68k.org, dmlb2000@gmail.com, linux-kernel@vger.kernel.org,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
References: <20070308175729.GA7054@kryten> <45F05040.4090602@zytor.com> <20070308214236.GA4154@kryten> <20070308.134825.45514445.davem@davemloft.net> <20070309024324.GA24695@kryten>
In-Reply-To: <20070309024324.GA24695@kryten>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard wrote:
> Hi,
> 
>> I might be missing something but doesn't this break every
>> SWAP partition that was created with something other than
>> MIN_PAGE_SIZE?
> 
> It does. I was thinking we could work around it in ppc64 (64kB is quite
> new), but I forgot there are options on sparc64 to change the page size :)
> 
> The other option is to create a v3 swap format that doesnt use any
> PAGE_SIZE parameters.
> 

The best thing to do would be to look for the magic both at PAGE_SIZE 
(for compatibility) and MIN_PAGE_SIZE (for sanity.)

	-hpa
