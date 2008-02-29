Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbYB2LBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbYB2LBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYB2LBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:01:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:60109 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759004AbYB2LBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:01:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=YnGPEze4O3xt4fczvyXRX1TbJHoYTLrTR6Nedzrmz6EvI8J/zexpudVuIsIPi99cbeRYRrMA/H0iMZjf/xrC0yceDRxFn/tsrGigH5sQsDZx7pcRM7F7DoJPRuzee0nmCSyOkuj9HvO9BxYHN4sEsFchknebJmUblh2ZvrB2b7A=
Message-ID: <47C7E607.6090308@gmail.com>
Date: Fri, 29 Feb 2008 12:01:27 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] soft lockup detected with ipcs
References: <47C7E280.4010805@gmail.com> <20080229025707.971ce0bd.akpm@linux-foundation.org>
In-Reply-To: <20080229025707.971ce0bd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no idea :) I noticed like 2 weeks ago... I probably changed some config,
but I dont remember what it was, I'll try to figure out.

Anyway I can reproduce this immediatelly, so I can run any diag you'd need to see.

jirka



Andrew Morton wrote:
> On Fri, 29 Feb 2008 11:46:24 +0100 Jiri Olsa <olsajiri@gmail.com> wrote:
> 
>> when I run 'ipcs' my system freeze up immediatelly.
>> I was able to get kernel BUG message once, I think it is not
>> printed out all the time it freeze.
>>
>> I tried on 2.6.24, 2.6.20 and 2.6.18.
>> I attached screenshot from 2.6.18 freeze and config.
> 
> how weird.  Lots of people are surely running ipcs and not seeing this.
> 
> Can you suggest what's different about your setup?

