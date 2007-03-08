Return-Path: <linux-kernel-owner+w=401wt.eu-S1030784AbXCHWOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030784AbXCHWOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030790AbXCHWOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:14:53 -0500
Received: from terminus.zytor.com ([192.83.249.54]:41683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030784AbXCHWOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:14:51 -0500
Message-ID: <45F08C60.6010404@zytor.com>
Date: Thu, 08 Mar 2007 14:21:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Avi Kivity <avi@argo.co.il>
CC: David Miller <davem@davemloft.net>, dmlb2000@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE Availability Inconsistency
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070305.160303.59493440.davem@davemloft.net> <9c21eeae0703051604l20a029c3r8cf09d792ba523be@mail.gmail.com> <20070305.162620.04006691.davem@davemloft.net> <45ECD03F.2040008@zytor.com> <45F07B63.1000105@argo.co.il>
In-Reply-To: <45F07B63.1000105@argo.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>>
>> It definitely should, especially on x86-64, where the page size isn't 
>> guaranteed by the ABI (on i386, the ABI guarantees a 4K page size; on 
>> x86-64 it can be up to 64K.)
> 
> Wouldn't that be ia64?

No, the x86-64 EFI ABI permits page sizes up to 64K.  Currently, of 
course, the only page size in use is 4K, but unlike i386 that's not 
guaranteed by the ABI.  At least AMD has indicated that they are 
considering introducing larger page size support in future hardware.

	-hpa
