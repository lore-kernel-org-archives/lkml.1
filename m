Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZGHTd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZGHTd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZGHTdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:33:22 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57362 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbZGHTdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pW3r5/i0IIv2AjNbzOq1xjn3atnQnGM2LJ4Ufc1KnWKsc5NI8TIjC+gOD8wnqYLCa5
         8D2R2LHkJElfzNil7dELL1Dzals8m6a5t04akuO/qrsMEr6RFIG+fbqsWHSYMx6AKCLf
         2S+L3kt4pevW3tN+l6wVcDzUoyX323G8hxGpI=
MIME-Version: 1.0
In-Reply-To: <1247078066.16156.15.camel@laptop>
References: <a5d9929e0907070825p78c1e527ud8f8d047767f621e@mail.gmail.com> 
	<1247078066.16156.15.camel@laptop>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Wed, 8 Jul 2009 20:32:52 +0100
Message-ID: <a5d9929e0907081232y2c043a05lff8868c3c5931e9e@mail.gmail.com>
Subject: Re: [PATCH 3/3] Increase lockdep limits: MAX_LOCKDEP_CHAINS_BITS
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 7:34 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Tue, 2009-07-07 at 16:25 +0100, Joao Correia wrote:
>> (Applies to current Linus tree, as of 2.6.31-rc2)
>>
>> A third limit becomes apparent as being too low after raising
>> MAX_STACK_TRACE_ENTRIES and MAX_LOCK_DEPTH, although this one is more
>> elusive to trigger.
>
> Would this involve reloading modules a lot?
>
>

All the other limits were triggered immediatly upon boot. This one
happens during regular system usage, after a couple of hours. Not
loading more modules than needed, the system stays at around 45
modules loaded, give or take. I do have qemu running, if that helps
anything.

Joao Correia
