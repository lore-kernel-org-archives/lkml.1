Return-Path: <linux-kernel-owner+w=401wt.eu-S933059AbZJLTGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbZJLTGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbZJLTGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:06:23 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:64172 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933016AbZJLTGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gPMUOS65GPLKfD8ne2IpbRWOIhhhkyxNg9cUgdgTMh/eM05MfHipeMvcRsUkjmHR7n
         TQBSSyBcYCkdKV3nDN4unuOYzPnTZnL5t0FudWv2AU6+gHFEtrpDieoxcvY+3KxXN0xm
         U0cUWYxmtwFBXh09wudU7EHm6wfTYuDMqaxnA=
Message-ID: <4AD37E05.5010504@gmail.com>
Date: Mon, 12 Oct 2009 21:05:41 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, edt@aei.ca,
       hirofumi@mail.parknet.co.jp, alan@linux.intel.com,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: keyboard under X with 2.6.31
References: <4AD17C6A.4030902@yahoo.co.uk> <alpine.LNX.2.01.0910111735140.19647@dyndns.pervalidus.net>
In-Reply-To: <alpine.LNX.2.01.0910111735140.19647@dyndns.pervalidus.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric L. W. Meunier wrote:
> On Sun, 11 Oct 2009, Boyan wrote:
> 
>> (sending again, sorry about last reply, wrong subject...)
>> On Sat, 10 Oct 2009 21:00:05 -0400, Ed Tomlinson wrote:
>>> You are not alone with keyboard problems in 31 in X.  In my case I
>>> blamed a  new wireless setup.
>>> I am building with the the above commit reverted.
>>
>> Not sure why, but after reverting
>> e043e42bdb66885b3ac10d27a01ccb9972e2b0a3 (pty: avoid forcing
>> 'low_latency' tty flag) my analog tv tuner stopped working after booting
>> for the first time. It has TV and FM radio, but only radio worked when
>> reverted this patch. I saw some EIO errors with strace. Then added again
>> the patch and on top of it I've added commit:
>>
>> 3a54297478e6578f96fd54bf4daa1751130aca86
>> pty: quickfix for the pty ENXIO timing problems
>>
>> Everything was ok.
>> Today I've tried to reproduce this and reverted both patches. Recompiled
>> and everything is ok. Not sure what happened yesterday.
>> So to summarize 2.6.31.3 with reverted commit
>> e043e42bdb66885b3ac10d27a01ccb9972e2b0a3 (pty: avoid forcing
>> 'low_latency' tty flag) works for me.
> 
> Reverting the commit also works for me. Thanks.
> 
> The direct link, for those not using git:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
 
CC'ing Greg K-H

