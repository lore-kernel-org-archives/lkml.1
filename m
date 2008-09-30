Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYI3X77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYI3X77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYI3X7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:59:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:44168 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYI3X7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BlDr1MndhkcY27g/XiGJp0uVZ5MZMfuW4QfO9EG4MNuZQEE99xTnc8x1MMfWD+psI0
         8+zUgvfjtGDagQaPLzoS45Epicuc99c2QRWRCCjLq7kly0pbN+gZZ3R1vA5phBIUimCE
         gBpMgGvZXnVFhndjX2fJWAxG8L5zdg8DdlS8o=
Message-ID: <86802c440809301659h4ff57a32r28e62b32386752e9@mail.gmail.com>
Date: Tue, 30 Sep 2008 16:59:49 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup update command line
Cc: "Randy Dunlap" <rdunlap@xenotime.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440809301652o72e2a54lf38dae39c59e4d51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080930165739.7847be37.rdunlap@xenotime.net>
	 <48E2B920.2020503@zytor.com>
	 <86802c440809301652o72e2a54lf38dae39c59e4d51@mail.gmail.com>
X-Google-Sender-Auth: 925e3a3169e0c372
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 4:52 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Sep 30, 2008 at 4:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Randy Dunlap wrote:
>>>
>>> E.g., the "apic" entries are not grouped together and these mtrr entries
>>> should
>>> not be grouped together unless they all begin with "mtrr", which is an
>>> option here:
>>> they could be renamed to "mtrr-cleanup" and "mtrr-nocleanup".
>>> And "disable_mtrr_trim" could be renamed to "mtrr-notrim".
>>>
>>
>> That does collide with the (not always kept) convention of prefixing "no" to
>> disable a boolean option, though.
>>
>
> it seems should group them and then provide one index section...
>
or
1. put all description in .c files
2. have one scripts to search early_param and __setup and create that
kernel_parameter...

YH
