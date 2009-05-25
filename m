Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbZEYGCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbZEYGCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 02:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZEYGCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 02:02:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52245 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZEYGCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 02:02:44 -0400
Message-ID: <4A1A344B.2000403@redhat.com>
Date: Mon, 25 May 2009 09:01:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: kvm/paging_tmpl.h intialize the variable before
 using it
References: <1242793775.3260.2.camel@localhost.localdomain>	 <4A193BCE.90307@redhat.com> <1243228626.3157.4.camel@localhost.localdomain>	 <4A1A2ADC.1090004@redhat.com> <1243229852.3157.19.camel@localhost.localdomain>
In-Reply-To: <1243229852.3157.19.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
>> That loop always has at least one iteration.
>>     
>
> hmm, In that case we should use a do-while flavor function so that the
> compiler will also happy with it.
>   

My own happiness requires that the loop not be rewritten.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

