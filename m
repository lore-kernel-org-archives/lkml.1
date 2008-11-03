Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYKCUB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYKCUB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYKCUBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:01:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:35263 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYKCUBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:01:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=nY6sjUTgUqj8O5vC09brq0TrBdmwX/iKVDsbAdk4TaHcAwVWra9F/U7rqaGB34U/+f
         KDyagGqtyCuWuGVp/kY2iMXgSt185qpvnInZ0ftbCCuSX6Ak6/ek4Ihy3+YmsyKaGUKm
         iZqb2REc+7Fvelhpi02Vi3OjcckoAZQiFaJeA=
Message-ID: <490F5897.6000103@gmail.com>
Date: Mon, 03 Nov 2008 22:01:27 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>, mingo@elte.hu,
       srostedt@redhat.com, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
 belongs to. Store thread group leader id, and use it to lookup the address
 in the process's map. We could have looked up the address on thread's map,
 but the thread might not exist by the time we are called. The process might
 not exist either, but if you are reading trace_pipe, that is unlikely.
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <1225742189.7803.1631.camel@twins> <20081103195838.GD32603@ghostprotocols.net>
In-Reply-To: <20081103195838.GD32603@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-03 21:58, Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 03, 2008 at 08:56:29PM +0100, Peter Zijlstra escreveu:
>   
>> fwiw, this is one amazing subject line.. ;-)
>>     
>
> Too much for "subject says it all." 8)

Yep, I've just learned that the first line in my git commit message will
be the subject line for the emails it sends out.

I'll use the shorter subject line suggested by Ingo next time ;)

Best regards,
--Edwin
