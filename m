Return-Path: <linux-kernel-owner+w=401wt.eu-S932906AbXHWXQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbXHWXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXHWXQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:16:18 -0400
Received: from gw.goop.org ([64.81.55.164]:59802 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950AbXHWXQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:16:17 -0400
Message-ID: <46CE1541.6040809@goop.org>
Date: Thu, 23 Aug 2007 16:16:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] enforce noreplace-smp in alternative_instructions()
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070822202551.GB31846@slug>
In-Reply-To: <20070822202551.GB31846@slug>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Deweerdt wrote:
> On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>   
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
>>
>>     
> Hi Jeremy,
>
> arch/i386/kernel/alternative.c:alternative_instructions() doesn't
> check for noreplace-smp before setting capability bits and freeing the
> __smp_locks section.
>
> Every call to alternatives_smp_unlock() checks for noreplace-smp
> beforehand, so remove the check from there.
>
> Boot tested on i386 with UP+noreplace-smp (lguest) and SMP (real hardware)
>   

Does this fix a real problem?  Or is there just some redundancy? 
Wouldn't it be better to put the noreplace_smp test in one place?

    J
