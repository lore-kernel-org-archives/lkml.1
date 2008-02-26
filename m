Return-Path: <linux-kernel-owner+w=401wt.eu-S1764672AbYBZUNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764672AbYBZUNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765174AbYBZUMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:12:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34171 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765157AbYBZUMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:12:19 -0500
Date: Tue, 26 Feb 2008 12:09:01 -0800
From: Greg KH <greg@kroah.com>
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: morgan@kernel.org, serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] add a private data field within kobj_attribute
	structure (final#2)
Message-ID: <20080226200901.GB10296@kroah.com>
References: <47C25AE9.7080305@ak.jp.nec.com> <47C25BD3.3020205@ak.jp.nec.com> <20080225065106.GB20997@kroah.com> <47C266E8.8040604@ak.jp.nec.com> <20080225074705.GA19885@kroah.com> <47C29293.4050305@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C29293.4050305@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 07:04:03PM +0900, Kohei KaiGai wrote:
> Greg KH wrote:
>> On Mon, Feb 25, 2008 at 03:57:44PM +0900, Kohei KaiGai wrote:
>>> Greg KH wrote:
>>>> On Mon, Feb 25, 2008 at 03:10:27PM +0900, Kohei KaiGai wrote:
>>>>> [PATCH 1/3] add a private data field within kobj_attribute structure.
>>>>>
>>>>> This patch add a private data field, declared as void *, within 
>>>>> kobj_attribute
>>>>> structure. The _show() and _store() method in the sysfs attribute 
>>>>> entries can
>>>>> refer this information to identify what entry is accessed.
>>>>> It makes easier to share a single method implementation with several 
>>>>> similar
>>>>> entries, like ones to export the list of capabilities the running 
>>>>> kernel
>>>>> supports.
>>>>>
>>>>> Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
>>>>> --
>>>>>  Documentation/kobject.txt |    6 ++++++
>>>> That's good, but you didn't modify the sample/kobject/ file to use the
>>>> new void pointer, instead of the strcmp() call.
>>> The 3/3 of patches updates sample/kobject to use the new void pointer.
>>> Do you want it to replace strcmp() examples completly?
>> Doh, I totally missed that one, very sorry.  I'll be glad to take
>> patches 1 and 3 in my tree, if you want me to.
>
> I want them to be upstreamed, no need to say.
>
> BTW, how do you think about the second patch which provides the most
> practical feature?

I personally have no opinion on this patch, sorry.

thanks,

greg k-h
