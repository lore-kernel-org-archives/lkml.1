Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYI3XxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYI3XxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYI3Xwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:52:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:43563 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbYI3Xwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=CfyIIpu2tnWKtrCX9IwHvELp/6UpgN4wVoWS5L0ZWPz9LgN7i8h7pnys9aKkwUAEbG
         6H7823gY/iPCcujFqpEdwnqPNrbwj2kcrKbgU0r2H4Q7tI2dJZ3DIhCiruV4r29U1alg
         4LMEGD+QH+BrZrz5EokDDLzrguilN3I7+ManU=
Message-ID: <86802c440809301652o72e2a54lf38dae39c59e4d51@mail.gmail.com>
Date: Tue, 30 Sep 2008 16:52:50 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup update command line
Cc: "Randy Dunlap" <rdunlap@xenotime.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48E2B920.2020503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080930165739.7847be37.rdunlap@xenotime.net>
	 <48E2B920.2020503@zytor.com>
X-Google-Sender-Auth: 256b81fee849b7b9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 4:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Randy Dunlap wrote:
>>
>> E.g., the "apic" entries are not grouped together and these mtrr entries
>> should
>> not be grouped together unless they all begin with "mtrr", which is an
>> option here:
>> they could be renamed to "mtrr-cleanup" and "mtrr-nocleanup".
>> And "disable_mtrr_trim" could be renamed to "mtrr-notrim".
>>
>
> That does collide with the (not always kept) convention of prefixing "no" to
> disable a boolean option, though.
>

it seems should group them and then provide one index section...

YH
