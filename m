Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbYJTP5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbYJTP5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 11:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYJTP5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 11:57:10 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:25059 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYJTP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 11:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pOxP4gbX22zK/2w89TBdarjVXcbd0BWoPek5TsvHruHRPmsvA3jaL+S1vyOe/sjGpX
         UrxEuJgWAer/pQ7xDlMM8EPFWcTprEthsVb7mitn0MP/GEeEcXspu+HiIHIsArpcyYxD
         y5BGxq78exfQ/Gv35Pfl3zjXjFmchBKBnRDVU=
Message-ID: <48FCAA4D.3030802@gmail.com>
Date: Mon, 20 Oct 2008 17:57:01 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andi Kleen <andi@firstfloor.org>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Slightly off topic] A question about R/B trees.
References: <48F904FA.6090102@gmail.com> <48F90E96.3060800@redhat.com>	 <87myh2jq55.fsf@basil.nowhere.org> <84144f020810180145p68a89d17y7609644f7b9d21bf@mail.gmail.com>
In-Reply-To: <84144f020810180145p68a89d17y7609644f7b9d21bf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Andi,
> 
> On Sat, Oct 18, 2008 at 10:53 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> The problem with hash tables is that if they're big enough
>> or if the rest of the workload is memory intensive
>> each hit will be a cache miss. And you can do a lot of branch
>> mispredicts in the time of a single cache miss.
>>
>> In general trees can be much better for cache usage, although
>> it's generally better to use some tree that has nodes near
>> the cache line size. Binary trees like RB are too small for that.
> 
> Right, but even for binary trees, you can get some of the benefits by
> packing all the nodes in a slab cache of their own. That way many of
> the neighboring nodes will share the same cache line if you're
> allocating memory for the nodes in a top-down order. Of course, you
> lose the benefits if the tree is updated a lot because you're back to
> worst case allocation again.
> 
>                        Pekka

Thank you very much.

Best regards,
	Maxim Levitsky
