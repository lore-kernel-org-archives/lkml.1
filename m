Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYDMVw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYDMVw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 17:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYDMVwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 17:52:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:64872 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYDMVwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 17:52:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mnDjbR3lTU3ckrv/bZmW2gbgMlO4e92pkFoEI6jstL+KrwjzABvTZYOWeOooVON0a9cntUdCwyvxOP2AjyhQ01R4B9SVqSP0nSVpApGZLRpfa/TmIwwvRx6a2+9cxIn3b7LbgkKj30WZnNc1fjNxW4OmBnHWGg+OvhMULfqqFAs=
Message-ID: <4802808F.9020209@gmail.com>
Date: Mon, 14 Apr 2008 01:52:15 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: David Erickson <halcyon1981@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel module unable to find an exported symbol
References: <740b8bba0804131418q4a210d44k77f95714002b92a@mail.gmail.com>
In-Reply-To: <740b8bba0804131418q4a210d44k77f95714002b92a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Erickson пишет:
> Hi everyone, I have two kernel modules I am developing, both use the
> call_rcu exported function. The core module finds it no problem,
> installs, and uses it.  The second module however when I try to insmod
> it complains:
> 
> Unknown symbol call_rcu
> 
> I have verified that it is exported via /proc/kallsyms:
> c04348c8 T call_rcu
> 
> I am at a loss as to how to proceed, can anyone shed some light on how
> this could be happening? Or how to diagnose and debug the problem?

It is very much possible that adding the following line to the source
code of your module will help:

MODULE_LICENSE("GPL");

HTH,
Dmitri

> 
> Thanks,
> David
> 
> ps please CC me on a reply, thank you!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

