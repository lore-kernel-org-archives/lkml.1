Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZHMH5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZHMH5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZHMH5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:57:39 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:35823 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZHMH5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OTP+Fp38FkB7Yl05rITzT1D227jT0VD8u7TrHWo6kpCQAlhkKzq9b8MNdCyeRHhBCm
         feRf4Dg8hON3QyalLjX+uUbL4YMR7wkvMfktL2H8zfijclaUVKrM6GFPc3Pp5DGEZQLW
         qFkzNZYfNRw4eDt9b8z1IoqEyTTUS7HIjuAVM=
MIME-Version: 1.0
In-Reply-To: <1250149366.10001.54.camel@twins>
References: <a8e1da0908121923j1fd291fbtb3576653ebd45bff@mail.gmail.com>
	 <1250149366.10001.54.camel@twins>
Date: Thu, 13 Aug 2009 15:57:38 +0800
Message-ID: <a8e1da0908130057q27af3d0cnb7a6132aeceec95f@mail.gmail.com>
Subject: Re: Top shows cpu usage 165% with kvm lunched
From: Dave Young <hidave.darkstar@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 3:42 PM, Peter Zijlstra<peterz@infradead.org> wrote:
> On Thu, 2009-08-13 at 10:23 +0800, Dave Young wrote:
>> Hi,
>>
>> Kvm guest runs slackware-current, doing extracting linux tarball, top
>> shows over 100% cpu usage. Is this a known issue?
>
> Does: top -H, show the same?

top -H show normal results with several qemu threads.

>
> I suspect it might be the cumulative cpu usage of several threads.

Thanks for telling, I never know top will hidden the thread usage.

-- 
Regards
dave
