Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZGYWya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZGYWya (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 18:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZGYWy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 18:54:29 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:58180 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZGYWy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 18:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WnIFvQDrWL+XmFN88qtql4p226ZvCiP9y4aPPr8amYQejrEFQdcHzHIHwzTf2/kOHN
         lg+PQbBqdTZl9jXcxcAl3U0uJeCLNa3elUILi0ulH8lZIL7Xr9+sSkMxJg1kjyhpA0Ka
         lOcqSXunN5cchrSXX4UbKFm4JAlwe+z8y2AQw=
MIME-Version: 1.0
In-Reply-To: <4A6ACE7C.9090409@orcon.net.nz>
References: <4A5DB243.2000100@orcon.net.nz>
	 <21d7e9970907152016u3b213beet9090ee3b34f6d8b1@mail.gmail.com>
	 <4A6ACE7C.9090409@orcon.net.nz>
Date: Sun, 26 Jul 2009 08:54:27 +1000
Message-ID: <21d7e9970907251554m18e4fca5p69b758e36fddc7d9@mail.gmail.com>
Subject: Re: Kernel 2.6.30.1 Oops on Alpha Architecture when starting Xserver
From: Dave Airlie <airlied@gmail.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       xorg@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> The kernel oops is:
>>>
>>
>> So its a machine check,
>>
>
> So, does this indicate a software fault (e.g. inconsistencies in kernel data
> structures) or does it imply a hardware fault?
>
>> Well X is trying to post the graphics card you have installed, and the
>> machine
>> is falling over when it does it.
>>
>
> SRM (the equivalent of a BIOS) cannot post the card on startup.  But I have
> had the card (radeon rv610) post correctly and working in the past when I
> compiled the complete 1.5.3 Xserver myself.  I had it working with both the
> radeon and radeonhd drivers and a 2.6.29.x kernel patched to support
> libpciaccess.

There is no -ati card in that machine, its got some SiS card which is
completely
different, maybe its some onboard card or something.

Dave.
