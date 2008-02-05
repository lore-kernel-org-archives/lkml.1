Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYBEGoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYBEGoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYBEGo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:44:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:39733 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYBEGo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=oONCblu6YR6CainVLCLTlGcskWAL69HybkVhjPNpbFq+n2d2PJgUhSbMrnGOb0YcriUxNif5lKWC8UIwJ/2WeD3fiigHP12CZupxAJOjGuoCMAVY9tFXNBMoXZFels51eqI+FBYldTnYHsGGqq95ctrQRdszD58XwtibJPq/nW8=
Message-ID: <47A805C3.9050303@gmail.com>
Date: Tue, 05 Feb 2008 13:44:19 +0700
From: Igor M Podlesny <for.poige+linux@gmail.com>
Reply-To: for.poige+linux@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071205 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: > best asked at one of the nvidia forums, not on lkml...
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>	<20080202235103.20dd9768.akpm@linux-foundation.org>	<47A71040.5000300@gmail.com>	<20080204052709.12f4e0d3.akpm@linux-foundation.org>	<47A7F4DB.3070406@gmail.com>	<47A80218.3040304@gmail.com> <20080204223430.415161e9@laptopd505.fenrus.org>
In-Reply-To: <20080204223430.415161e9@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-02-05 13:34, Arjan van de Ven wrote:
[...]
>> 	1) To have compiled it I had to replace global_flush_tlb()
>> call with __flush_tlb_all() and still guessing was it(?) a correct
>> replacment at all :-)
> 
> it is not; 

	I see, thanks. What would be the correct one? ;-)
>> 
>> 	2) When loading it emits such messages:
>> 
>> 		nvidia: Unknown symbol change_page_attr
>> 		nvidia: Unknown symbol init_mm
>> 
>> 	Can it be quick and easy solved?
> 
> best asked at one of the nvidia forums, not on lkml...
> they need to adjust a few API calls, it's not hard work but they need
> to do that (their driver isn't open source)

	You're right.

-- 
