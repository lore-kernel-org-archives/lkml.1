Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYBYKE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYBYKE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYBYKET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:04:19 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:46871 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYBYKES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:04:18 -0500
Message-ID: <47C29293.4050305@ak.jp.nec.com>
Date: Mon, 25 Feb 2008 19:04:03 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: morgan@kernel.org, serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] add a private data field within kobj_attribute	structure
 (final#2)
References: <47C25AE9.7080305@ak.jp.nec.com> <47C25BD3.3020205@ak.jp.nec.com> <20080225065106.GB20997@kroah.com> <47C266E8.8040604@ak.jp.nec.com> <20080225074705.GA19885@kroah.com>
In-Reply-To: <20080225074705.GA19885@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Feb 25, 2008 at 03:57:44PM +0900, Kohei KaiGai wrote:
>> Greg KH wrote:
>>> On Mon, Feb 25, 2008 at 03:10:27PM +0900, Kohei KaiGai wrote:
>>>> [PATCH 1/3] add a private data field within kobj_attribute structure.
>>>>
>>>> This patch add a private data field, declared as void *, within 
>>>> kobj_attribute
>>>> structure. The _show() and _store() method in the sysfs attribute entries 
>>>> can
>>>> refer this information to identify what entry is accessed.
>>>> It makes easier to share a single method implementation with several 
>>>> similar
>>>> entries, like ones to export the list of capabilities the running kernel
>>>> supports.
>>>>
>>>> Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
>>>> --
>>>>  Documentation/kobject.txt |    6 ++++++
>>> That's good, but you didn't modify the sample/kobject/ file to use the
>>> new void pointer, instead of the strcmp() call.
>> The 3/3 of patches updates sample/kobject to use the new void pointer.
>> Do you want it to replace strcmp() examples completly?
> 
> Doh, I totally missed that one, very sorry.  I'll be glad to take
> patches 1 and 3 in my tree, if you want me to.

I want them to be upstreamed, no need to say.

BTW, how do you think about the second patch which provides the most
practical feature?

Thanks for your reviewing.
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
