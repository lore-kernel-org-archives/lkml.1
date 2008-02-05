Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYBEG25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYBEG25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYBEG2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:28:49 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:59947 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYBEG2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:28:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=j7z7coOL6OZKN0OPm3yKh7x3vEVi4clEmdveJU45kuvTFsvYLm8jUidWTG4tSe8t4EZq7lZOhR5gAbN2rcA4y94pqXck3FDyZg7A7Waoz1MSNGLsq1z5/uw/+1MCbNCHnpwVx1iCjHZ5Ark4GaPy0LB7D4h0sRdqtTfEdGZ1OTo=
Message-ID: <47A80218.3040304@gmail.com>
Date: Tue, 05 Feb 2008 13:28:40 +0700
From: Igor M Podlesny <for.poige+linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071205 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: NVIDIA's Linux x86 Display Driver fresh driver isn't compatible anymore
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>	<20080202235103.20dd9768.akpm@linux-foundation.org>	<47A71040.5000300@gmail.com> <20080204052709.12f4e0d3.akpm@linux-foundation.org> <47A7F4DB.3070406@gmail.com>
In-Reply-To: <47A7F4DB.3070406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-02-05 12:32, Igor M Podlesny wrote:
> On 2008-02-04 20:27, Andrew Morton wrote:
>> On Mon, 04 Feb 2008 20:16:48 +0700 Igor M Podlesny <for.poige+linux@gmail.com> wrote:
> [...]
>>>    Now I can say that both 2.6.24-mm1 and 2.6.24-git11 do NOT "see" any
>>> of mine LVM-2 disks. pvscan, for e.g., finds nothing at all.
>> 
>> You may find that you need to update your lvm userspace tools.
> 
> 	You're right; I've updated my initrd with fresh lvm
> userspace-counterpart and now the problem has been fixed. Sorry for
> groundless alert.
> 
> 	Thanks!

	But as russian proverb says, trouble never comes alone. :-) NVIDIA's fresh driver
isn't compatible anymore:

	1) To have compiled it I had to replace global_flush_tlb() call with
__flush_tlb_all() and still guessing was it(?) a correct replacment at all :-)

	2) When loading it emits such messages:

		nvidia: Unknown symbol change_page_attr
		nvidia: Unknown symbol init_mm

	Can it be quick and easy solved?
	
-- 
End of message. Next message?
