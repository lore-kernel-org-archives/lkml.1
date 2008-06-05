Return-Path: <linux-kernel-owner+w=401wt.eu-S1759707AbYFEVdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707AbYFEVdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYFEVd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:33:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34414 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbYFEVdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:33:25 -0400
Message-ID: <48485BA3.60809@garzik.org>
Date: Thu, 05 Jun 2008 17:33:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
References: <20080605.foo@pmac.infradead.org>  <48483BA9.1070200@garzik.org>	 <1212695675.32207.288.camel@pmac.infradead.org>	 <4848489C.6010903@garzik.org>	 <1212699190.32207.293.camel@pmac.infradead.org>	 <48485435.7020308@garzik.org> <1212268943.2534.16.camel@shinybook.infradead.org>
In-Reply-To: <1212268943.2534.16.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Thu, 2008-06-05 at 17:01 -0400, Jeff Garzik wrote:
>> If the sha1 sum of what is in the kernel tree differs from what the 
>> vendor provided, then it is OBVIOUSLY more difficult to verify that
>> you have the original firmware as provided by the vendor.
>>
>> Put the binary blobs into the git tree, __without modification or 
>> wrapping__.
> 
> We don't have them in that form right now. Of the firmware blobs I've
> encountered so far -- even the ones which were in a file on their own --
> none of them are in binary form; they're _all_ in some ASCII
> representation which can be processed with 'diff'. That includes char
> arrays, arrays of larger integers which need endian-awareness, 'hex
> record' structures, and probably a bunch of other abominations I have
> yet to encounter as I work through them.
> 
> None of them have just been binary files in the source tree.

Right.  And now you are creating Yet Another Format, rather than 
rendering the firmware back into the preferred format:  binary blob.

_If_ you are changing form of current in-tree firmwares at all, there is 
no excuse not use direct binary blob -- the least common denominator for 
all relevant operations.

Storing the firmware in .ihex is just as bad as storing the firmware in 
source code -- it's a pointless wrapper that makes firmware verification 
and updates far more difficult than they should be.

	Jeff



