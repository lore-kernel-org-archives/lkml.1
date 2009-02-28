Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbZB1IRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbZB1IRe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZB1IR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:17:26 -0500
Received: from gw.goop.org ([64.81.55.164]:43831 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbZB1IR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:17:26 -0500
Message-ID: <49A8F313.8010007@goop.org>
Date: Sat, 28 Feb 2009 00:17:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: J
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu>
In-Reply-To: <20090228071534.GB9351@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> What are you asking?  __brk_base is _end rounded up to a page 
>> boundary, so head_32.S can use it directly for pagetable 
>> allocation.  Are you flagging the '&' typo?  Something else?
>>     
>
> it's not really a typo either (__brk_base and &__brk_base should 
> be the same) - just a bit weird looking.

It's a typo in that I didn't mean it to come out like that.  But yes, it 
makes no difference.

    J
