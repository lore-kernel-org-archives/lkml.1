Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbZGHTeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbZGHTeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZGHTeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:34:00 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:44173 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZGHTd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vV+2yoPHO5UemhyXh6WQcgmmhk5lTH3aIVuNfsDkqkIs4bhzxEJIU7JHmMwAz8m3w8
         efmVKONrrBbgAsUFLLAJq5xudjSp20R+4yK8f0+N6W7A2AE3NxuglKviiSuYxT/Rvo6s
         Xvq3fzorMT6OBP18hlxQIylJNVrog/cIUAYW4=
MIME-Version: 1.0
In-Reply-To: <a5d9929e0907081232y2c043a05lff8868c3c5931e9e@mail.gmail.com>
References: <a5d9929e0907070825p78c1e527ud8f8d047767f621e@mail.gmail.com> 
	<1247078066.16156.15.camel@laptop> <a5d9929e0907081232y2c043a05lff8868c3c5931e9e@mail.gmail.com>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Wed, 8 Jul 2009 20:33:37 +0100
Message-ID: <a5d9929e0907081233s6fc42c15k710047a1b0dcc5bf@mail.gmail.com>
Subject: Re: [PATCH 3/3] Increase lockdep limits: MAX_LOCKDEP_CHAINS_BITS
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 8:32 PM, Joao Correia<joaomiguelcorreia@gmail.com> wrote:
> On Wed, Jul 8, 2009 at 7:34 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
>> On Tue, 2009-07-07 at 16:25 +0100, Joao Correia wrote:
>>> (Applies to current Linus tree, as of 2.6.31-rc2)
>>>
>>> A third limit becomes apparent as being too low after raising
>>> MAX_STACK_TRACE_ENTRIES and MAX_LOCK_DEPTH, although this one is more
>>> elusive to trigger.
>>
>> Would this involve reloading modules a lot?
>>
>>
>
> All the other limits were triggered immediatly upon boot. This one
> happens during regular system usage, after a couple of hours. Not
> loading more modules than needed, the system stays at around 45
> modules loaded, give or take. I do have qemu running, if that helps
> anything.
>
> Joao Correia
>

qemu running as a -host-, not the system running inside it. Just to clear it up.

Joao Correia
