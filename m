Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYI3VfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYI3VfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 17:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYI3VfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 17:35:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:31059 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYI3VfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 17:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gs/j9fjaOy2tC/sMyosdsyqBr1KQ5fgfFWlOqGP5ABvlSXzXn7TpZiHVFOxnFUG/tT
         5JkJOW/+Bx32UoY6PzM+iyNJ5XPhSyMZI6N5cI0RxkiP+xgco+dWi/oukUkjA22wF6+e
         SrlcpTup1GpN8kuQRP6kV+l1ZxWWVDUU9TZmU=
Message-ID: <86802c440809301435r79fb2553p65130b6451e83fa4@mail.gmail.com>
Date: Tue, 30 Sep 2008 14:35:09 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Typo bug [Re: Linux 2.6.27-rc8]
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "=?ISO-8859-1?Q?\"J.A._Magall=F3n\"?=" <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48E28528.5070605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
	 <20080930094346.307ef1e5@werewolf.home>
	 <20080930075553.GB20241@elte.hu> <48E27425.7010705@zytor.com>
	 <86802c440809301230s7dd33e69m83dab51f915580b1@mail.gmail.com>
	 <48E28528.5070605@zytor.com>
X-Google-Sender-Auth: 20162fed977f4e5d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 12:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> On Tue, Sep 30, 2008 at 11:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> Ingo Molnar wrote:
>>>>>
>>>>> early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
>>>>>            ^^^^^^
>>>>>
>>>>> Nice ;)
>>>>
>>>> heh. Could you send a patch with a changelog please?
>>>
>>> These options are also named inconsistently with all other options.
>>>
>>> The standard way to name an boolean option is "foo" versus "nofoo", in
>>> this
>>> case, "mtrrcleanup" vs "nomtrrcleanup".
>>>
>> ok, we could change it...
>
> If we're fixing a typo anyway I'd suggest so.  We know we're not breaking
> anyone's working setup...

mtrr_cleanup and no_mtrr_cleanup?

YH
