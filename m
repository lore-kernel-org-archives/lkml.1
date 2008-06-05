Return-Path: <linux-kernel-owner+w=401wt.eu-S1762653AbYFEVBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbYFEVBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYFEVBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:01:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33004 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbYFEVBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:01:43 -0400
Message-ID: <48485435.7020308@garzik.org>
Date: Thu, 05 Jun 2008 17:01:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
References: <20080605.foo@pmac.infradead.org>  <48483BA9.1070200@garzik.org>	 <1212695675.32207.288.camel@pmac.infradead.org>	 <4848489C.6010903@garzik.org> <1212699190.32207.293.camel@pmac.infradead.org>
In-Reply-To: <1212699190.32207.293.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Thu, 2008-06-05 at 16:12 -0400, Jeff Garzik wrote:
>> Well, I should ask, is this purely an internal build detail?
>>
>> The developer (and user) should never ever see a .ihex file, outside of 
>> an active kernel compile.  Wrapping the original firmware makes it more 
>> difficult to verify, compare and/or change.  In-tree, we should see the 
>> vendor firmware blobs as shipped, with no wrapping or modification or 
>> anything.
> 
> It's a build-and-shipping detail, at least in the kernel source tree.
> 
> Rather than putting binary blobs into git (which admittedly we could,
> but it's suboptimal), we just run them through 'objcopy -Oihex' first.
> 
> It's not 'wrapped'; it's not any more difficult to verify, compare or
> change.

If the sha1 sum of what is in the kernel tree differs from what the 
vendor provided, then it is OBVIOUSLY more difficult to verify that you 
have the original firmware as provided by the vendor.

Put the binary blobs into the git tree, __without modification or 
wrapping__.

	Jeff



