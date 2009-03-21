Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZCURDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZCURDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 13:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZCURDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 13:03:04 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48542 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbZCURDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 13:03:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kMmaLa3/ZagpWoyaAQSGMDvRhr/sp15Yo7oJ/D6Bdq3tpt2CPgDsZ+HDk8actDh0tT
         V8idU6vDtGCIFmiP9kd2CdQBY418LX0nPm1EkyfNiMhkteHRqBizSdjt3b4CfBJJKUxM
         lJz47zx/2LPrfvkEyUYQfok0cin/t0lCutqfU=
Message-ID: <49C51DBE.4000403@googlemail.com>
Date: Sat, 21 Mar 2009 18:02:54 +0100
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: ptrace performance
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera> <qm8_cedJGaP.A.c1H.2PCvJB@chimera> <49C4FD41.4030504@googlemail.com> <20090321152217.GB1073@elte.hu>
In-Reply-To: <20090321152217.GB1073@elte.hu>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:

> that's almost certainly due to the wait_task_inactive() change. Does 
> the patch below improve things?

That makes it *much* better - dd reports more than 3 GB/s on the Core
Duo. I'll have to check the other systems later; they're busy at the moment.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
