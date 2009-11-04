Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbZKDGnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbZKDGnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZKDGnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:43:52 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:61271 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZKDGnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:43:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MLY8Ma9L0rRiumdZonO7CEABYI5XZOntXyp5X5eBVFW0o2+6vytyeib04ukOi2j4Kx
         MziZ4EmDJGCf3do2kHKO8gugRJhjltVWFu1wuEzqQfFK8aI75gEPAl03JqelTh5jYZq4
         7ulDo+mW858JyZ/k/zllNWknZgSokfAU7KNkU=
Message-ID: <4AF122BB.7000202@gmail.com>
Date: Tue, 03 Nov 2009 22:44:11 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@cs.washington.edu>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com> <20091103222432.4a94bd8f.akpm@linux-foundation.org>
In-Reply-To: <20091103222432.4a94bd8f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 2 Nov 2009 13:29:29 -0800 Justin Mattock<justinmattock@gmail.com>  wrote:
>
>    
>> Hello,
>> I'm not sure how to handle this,
>> while compiling firefox-3.6b1.source
>> I get this with the default compiling options,
>> as well as custom:
>>
>> ...
>>
>> active_anon:2360492kB inactive_anon:590196kB active_file:84kB
>>      
>
> 2.8GB of anonymous memory
>
>    
figured it would be good enough
(I think I have 4gig's total)
>> [  532.942508] Free swap  = 0kB
>> [  532.942510] Total swap = 431632kB
>>      
>
> 430MB of swap, all used up.
>
>    
yep, narrow down to the smallest amount.
> That's a genuine OOM.  Something (presumably cc1plus) has consumed
> waaaay too much memory, quite possibly leaked it.
>
> It would help if the oom-killer were to print some information about
> the oom-killed process's memory footprint.
>
>
>    
I still have everything setup(if you need me to add a debug patch
let me know)
as for compiling: libc compiled fine, kernel fine,
and every package on the clfs list up to boot up the fresh system.
(was figuring out how to compiling/install firefox before
  I threw the old system away).

stable gcc(4.4*) on the macbook(same os/kernel) compiled fine
firefox, xulrunner, and in the process thunderbird...

Justin P. Mattock
