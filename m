Return-Path: <linux-kernel-owner+w=401wt.eu-S1751330AbZBZFZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbZBZFZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZBZFZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:25:06 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:58159 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZBZFZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:25:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T6EZNJCBm9NBTM7dV/bWmh2N6hXnhsKoWHo9ky6mKMdX0ybeYXRr3r5ZtjLR97+9OS
         Qk8IgfAsvKKkZkTgv37PBumto8hb/qmbTgWlNS+L2G+j4QlIKiKvnouxyLe0Nlr9iwhG
         HDjshDQE0qP1FWv0M699abaM4WN1gVzSFD2+I=
MIME-Version: 1.0
In-Reply-To: <aa79d98a0902252004n2d9d06fcpf2b2ff20f1c8442a@mail.gmail.com>
References: <20090225205920.GA22091@localhost> <20090226030315.GB7526@elte.hu>
	 <1235617541.5610.0.camel@brick> <20090226031301.GE7526@elte.hu>
	 <1235618574.5610.1.camel@brick> <20090226032544.GB22223@elte.hu>
	 <aa79d98a0902252004n2d9d06fcpf2b2ff20f1c8442a@mail.gmail.com>
Date: Thu, 26 Feb 2009 08:25:01 +0300
Message-ID: <aa79d98a0902252125i27cb8c5u5d56918d89e48b71@mail.gmail.com>
Subject: Re: [RFC] introduce pr_cont macro
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 7:04 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 2/26/09, Ingo Molnar <mingo@elte.hu> wrote:
...
>>
>> Btw., why do those macros use ##__VA_ARGS__ ? Why not a
>> straightforward:
>>
>>  #define __pr_cont(args...) \
>>       printk(KERN_CONT args)
>>
>> ?
>>
>>       Ingo
>
> Grr... Thanks for catching me! Ingo, Harvey could you drop this patch
> and make new one in good shape?
>

I'll make new one today evening then. Drop all this. Thanks!
