Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZEZLp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZEZLp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 07:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZEZLpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:45:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbZEZLpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:45:49 -0400
Message-ID: <4A1BD62B.4050206@redhat.com>
Date: Tue, 26 May 2009 14:44:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: kvm/paging_tmpl.h intialize the variable	before
 using it
References: <1242793775.3260.2.camel@localhost.localdomain> <4A193BCE.90307@redhat.com> <20090525060531.GA16990@elte.hu>
In-Reply-To: <20090525060531.GA16990@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

  

>> It's a false alarm.  Isn't there a macro to shut up the warning?
>>     
>
> there's uninitialized_var(), but that will shut up the warning and 
> any _correct_ future warning - so it's dangerous. Initialize it to 
> NULL and be done with it? We dont want stray warnings in the kernel.
>   

Makes sense, so I've applied the patch.

-- 
error compiling committee.c: too many arguments to function

