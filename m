Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0BIG11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 01:27:27 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63616 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0BIG10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 01:27:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q3Kqk+UahC78c60axvny+6TYF4z42ugjVMcIw9XEO+VBb99zL6cfpDSezRigUFAZKM
         jqLWUTAKknSG3TbDpmQ2xtG8B2MMRc0/Pws2+PLSaUdup3G3T7dtpPOxIVGSZ6HAO46L
         VGN7T1VkKT8xrOLc2hkFH0Ia6fbrRNoiBH/v8=
MIME-Version: 1.0
In-Reply-To: <20100208220753.61a39bab.akpm@linux-foundation.org>
References: <20100206134056.GB2562@darkstar>
	 <20100208135654.04b79bbc.akpm@linux-foundation.org>
	 <a8e1da1002081831j6fdea8a7v41cc07b635ab7dda@mail.gmail.com>
	 <a8e1da1002082156s3145a775o7424bc47ac503636@mail.gmail.com>
	 <20100208220753.61a39bab.akpm@linux-foundation.org>
Date: Tue, 9 Feb 2010 14:27:25 +0800
Message-ID: <a8e1da1002082227s6bebd2e8id0f6c6a04d832d24@mail.gmail.com>
Subject: Re: [PATCH 2/2] allow printk delay after multi lines
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 2:07 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 9 Feb 2010 13:56:34 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> BTW, for the sysctl variables. I found in kernel.h there's:
>> printk/console_loglevel/panic related extern variables for sysctl.
>>
>> console_loglevel and panic related variables are used here and there,
>> not just for sysctl, so I think it should stay in kernel.h.
>>
>> The printk related variables for sysctl and all the extern variables in
>> sysctl.c can be move to sysctl.h. Seems no need new head file.
>>
>> Andrew, what's your opinion?
>
> Symbols which are defined in printk.c and which are used in other
> compilation units should be declared in printk.h!
>
> We mucked up in the past by putting these things in kernel.h and as
> externs in sysctl.c, but that's no reason to continue to do so.  As a
> special-case, it makes convenience sense to declare printk() itself and
> the loglevel strings etc in kernel.h, but that _is_ a special case.
>

Lazy is bad, hehe :)
Will do that in a updated patchset, Thanks.

-- 
Regards
dave
