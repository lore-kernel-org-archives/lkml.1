Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbYDVJJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbYDVJJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757158AbYDVJI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:08:57 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:34830 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064AbYDVJIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=LiP8sU8IKWis8gZPsa9WnUc8YOAW0JDZSW/0azZH7yB2GGDQrjM/97nNLPMEjKJMQfakNyPUOSdzpb0IOFxcIGYgSmx45070aWEgfGLEHcG7aCPcEH59N18y1lCIjEVwE0YAGWfW5ZzjczeHhBbRxbylLAQwxS9hjB8AHbyEJ/k=
Message-ID: <480DAA34.7010709@gmail.com>
Date: Tue, 22 Apr 2008 11:04:52 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function
  calls
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-3-git-send-email-jens.axboe@oracle.com> <20080422084738.GB2388@elte.hu> <480DA670.4060707@gmail.com> <20080422085629.GV12774@kernel.dk>
In-Reply-To: <20080422085629.GV12774@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe pisze:
> On Tue, Apr 22 2008, Jacek Luczak wrote:
>> Ingo Molnar pisze:
>>> * Jens Axboe <jens.axboe@oracle.com> wrote:
>>>
>>>> This converts x86 and x86-64 to use the new helpers for 
>>>> smp_call_function() and friends, and adds support for 
>>>> smp_call_function_single().
>>> nice stuff. The x86 and generic bits:
>>>
>>>  Acked-by: Ingo Molnar <mingo@elte.hu>
>>>
>>> this has been brewing for months, what is the testing/confidence status 
>> A'propos testing: Jens did you placed all patches (latest versions)
>> somewhere on net, so I can grab it and test?
> 
> It's in git as well, generic-ipi branch. So you can pull it into current
> linus by doing:
> 
> $ git pull git://git.kernel.dk/linux-2.6-block.git generic-ipi

OK, thanks. I've got number of unused x86 boxes, so I will give it a spin.

Jacek
