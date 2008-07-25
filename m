Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbYGYQ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbYGYQ7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYGYQ67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:58:59 -0400
Received: from gw.goop.org ([64.81.55.164]:40911 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYGYQ66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:58:58 -0400
Message-ID: <488A064E.1040407@goop.org>
Date: Fri, 25 Jul 2008 09:58:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F30C.8020800@zytor.com> <4874F909.7060503@goop.org> <4889F5FA.1050908@sgi.com> <4889FA96.1000701@goop.org> <488A0375.4050605@sgi.com>
In-Reply-To: <488A0375.4050605@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Mike Travis wrote:
>>     
>>> FYI, I think it was a combination of errors that was causing my problems.
>>> In any case, I've successfully compiled and booted Ingo's pesky config
>>> config-Tue_Jul__1_16_48_45_CEST_2008.bad with gcc's 4.2.0, 4.2.3 and
>>> 4.2.4
>>> on both Intel and AMD boxes.  (As well as a variety of other configs.)
>>>   
>>>       
>> Good.  What compilers have you tested?  Will it work over the complete
>> supported range?
>>     
>
> The oldest gcc I have available is 3.4.3 (and I just tried that one and
> it worked.)  So that one and the ones listed above I've verified using
> Ingo's test config.  (All other testing I'm using 4.2.3.)
>   

OK.  I've got a range of toolchains on various test machines around 
here, so I'll give it a spin.  Are your most recent changes in tip.git yet?

    J
