Return-Path: <linux-kernel-owner+w=401wt.eu-S1751305AbZJKUkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbZJKUkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 16:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZJKUkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 16:40:07 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:53846 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZJKUkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 16:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:x-archive:mime-version:content-type;
        b=SeE/aZjpIeylNodFsD9h3DEDybZpiezUIgdHXqqbDwFtRK6Jy4dEjNvGDONJFL/shs
         ej5/SXTZT5z15hWO2RVZuaTfrJurgBPCgVwk2dSr3PVVDh8qljcr2pG6gtPj2wN/LwC+
         hSDHhyJW+AEsbCyziRMGoGPNMT4LSYfvEWj00=
Date: Sun, 11 Oct 2009 17:39:22 -0300 (BRST)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
cc: edt@aei.ca, hirofumi@mail.parknet.co.jp, alan@linux.intel.com
Subject: Re: keyboard under X with 2.6.31
In-Reply-To: <4AD17C6A.4030902@yahoo.co.uk>
Message-ID: <alpine.LNX.2.01.0910111735140.19647@dyndns.pervalidus.net>
References: <4AD17C6A.4030902@yahoo.co.uk>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009, Boyan wrote:

> (sending again, sorry about last reply, wrong subject...)
> On Sat, 10 Oct 2009 21:00:05 -0400, Ed Tomlinson wrote:
>> You are not alone with keyboard problems in 31 in X.  In my case I
>> blamed a  new wireless setup.
>> I am building with the the above commit reverted.
>
> Not sure why, but after reverting
> e043e42bdb66885b3ac10d27a01ccb9972e2b0a3 (pty: avoid forcing
> 'low_latency' tty flag) my analog tv tuner stopped working after booting
> for the first time. It has TV and FM radio, but only radio worked when
> reverted this patch. I saw some EIO errors with strace. Then added again
> the patch and on top of it I've added commit:
>
> 3a54297478e6578f96fd54bf4daa1751130aca86
> pty: quickfix for the pty ENXIO timing problems
>
> Everything was ok.
> Today I've tried to reproduce this and reverted both patches. Recompiled
> and everything is ok. Not sure what happened yesterday.
> So to summarize 2.6.31.3 with reverted commit
> e043e42bdb66885b3ac10d27a01ccb9972e2b0a3 (pty: avoid forcing
> 'low_latency' tty flag) works for me.

Reverting the commit also works for me. Thanks.

The direct link, for those not using git:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
