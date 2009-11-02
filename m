Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbZKBQ4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbZKBQ4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbZKBQ4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:56:39 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:57830 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbZKBQ4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:56:39 -0500
MIME-Version: 1.0
In-Reply-To: <4AEF0D0B.1000100@austin.ibm.com>
References: <4AE8ADCF.6090104@austin.ibm.com> <4AE8AF4D.4030403@austin.ibm.com> 
	<1256785731.26770.38.camel@pasglop> <4AEF086D.9010600@austin.ibm.com> 
	<fa686aa40911020840s3a6a4819g85f3be3a305820bf@mail.gmail.com> 
	<4AEF0D0B.1000100@austin.ibm.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 2 Nov 2009 09:56:21 -0700
X-Google-Sender-Auth: eb83f1fa9afed273
Message-ID: <fa686aa40911020856u1dba88feib46cb40dce7de6dc@mail.gmail.com>
Subject: Re: [PATCH 1/6 v5] Kernel DLPAR Infrastructure
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 9:47 AM, Nathan Fontenot <nfont@austin.ibm.com> wrote:
> Grant Likely wrote:
>>
>> On Mon, Nov 2, 2009 at 9:27 AM, Nathan Fontenot <nfont@austin.ibm.com>
>> wrote:
>>>
>>> I saw that Grant Likely is doing updates to all of the of_* stuff right
>>> now,
>>> would it be ok to have these routines here, renamed as dlpar_*, and look
>>> to merge them in with Grant's updates when he finishes?
>>
>> No because then we're stuck with renaming the API at a later date.
>> Name it what it is, and put it where it belongs.  I'll deal with any
>> merge breakage as it occurs.
>>
>
> ok.  Would this be better off in powerpc code, or should I go ahead and put
> it
> in something like drivers/of/dynamic.c?

drivers/of/dynamic.c sounds fine to me.  I can always move them if it
find a better place.  Send the patch to me and cc: the
devicetree-discuss@lists.ozlabs.org mailing list.

g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
