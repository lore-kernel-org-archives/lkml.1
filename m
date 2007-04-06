Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbXDFQdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbXDFQdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933213AbXDFQdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:33:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:8198 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933212AbXDFQdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:33:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=sWjcCnsIopLr6nPxCO+24WSUOv7KasfUB/CiNj2PmY2oMgpuZV2gAFRDIbuEQTUXQ
	RL+dX/SSx/Y8dOEZ2itpA==
Message-ID: <4616765C.3050509@google.com>
Date: Fri, 06 Apr 2007 09:33:32 -0700
From: Martin Bligh <mbligh@google.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leave loglevel at 7 through sysrq output so you can actually
 read it
References: <46157DD2.4050502@google.com> <Pine.LNX.4.64.0704061830401.14458@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0704061830401.14458@scrub.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:
> 
> On Thu, 5 Apr 2007, Martin Bligh wrote:
> 
>> We carefully set loglevel to 7, and print the sysrq messsage
>> as to what event we're doing, but we can't actually see
>> the output as it sets it back before calling the handler,
>> rather than after.
>>
>> Move the assignment down one line.
> 
> I think you have to tell sysrq_handle_loglevel() about this too...

Not sure why? That just changes the current loglevel, and seems
unaffected.

I did test the patch, and it works fine.

M.
