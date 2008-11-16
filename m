Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbYKPFZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbYKPFZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 00:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYKPFY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 00:24:58 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:32513 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYKPFY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 00:24:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ez4Pj3zh9U2eB2juE4RHxK8r40RyHK1V5cRUB94w5qxcBSMr8j9a+wZVn2vpJvoHZ9
         UJ0CNEXM687CPS6HSADGdxM2zPLLF4OGUisEQqNjXm7n6RjA4MUpTd6TMn6/QrDG4ego
         mNe37cL+a7yPvdSd/Wt6Hl+zCmhPP4+zg68tw=
Message-ID: <491FAEB8.5010501@gmail.com>
Date: Sun, 16 Nov 2008 14:25:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] depmod: sort output according to modules.order, take
 #2
References: <475936CE.70703@gmail.com> <475BB5AE.40503@gmail.com>	 <477B71F0.8020706@gmail.com>  <200801031012.22776.rusty@rustcorp.com.au>	 <1199318319.2044.22.camel@perihelion>  <491C1158.8090901@gmail.com> <1226776813.4894.1.camel@jcmlaptop>
In-Reply-To: <1226776813.4894.1.camel@jcmlaptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> On Thu, 2008-11-13 at 20:36 +0900, Tejun Heo wrote:
> 
>> Jon, this patch hasn't made into module-init-tools
> 
> I'm redoing it to cope with the binary sorted output files we have now -
> i.e. we can't just rely upon the order of modules.dep any more, what
> you're actually trying to do with modules.order is ensure that e.g.
> modules providing conflicting aliases get handled in "order".

Yes, that's right.  Ah... so, now modules.dep is sorted to speed up
module look up?  Is this code already in module-init-tools?

Thanks.

-- 
tejun
