Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbYASLVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbYASLVo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 06:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYASLVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 06:21:37 -0500
Received: from ag-out-0708.google.com ([72.14.246.240]:41890 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYASLVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 06:21:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=AH5ybAPUmkcqU+ZLuvrWHdOL19ehZcJiI3Kanqdeg1A2RJFQcVxOwYY/om7fcAdZWAIUVtNqJjvxlOvE+gKpnT2TCn6UgwtXnNRlFkRbTwr0VXz6KWFIJWpaQox7X6WeqvcsMBEiJG7oeGh6TMp5pevdAt7EzBcHLClSIs0FA08=
Date: Sat, 19 Jan 2008 19:20:02 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: build #343 issue for v2.6.24-rc8-29-g03bbe08 : Section
	mismatch: reference to .init.text.1:start_kernel (between 'is386'
	and 'check_x87')
Message-ID: <20080119112002.GA2466@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200801181318.30009.toralf.foerster@gmx.de> <20080118122917.GH2559@hacking> <20080118124627.GA17918@uranus.ravnborg.org> <20080118125144.GI2559@hacking> <20080118132242.GA18183@uranus.ravnborg.org> <20080118161452.GJ2559@hacking> <20080118184755.GA20020@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118184755.GA20020@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 07:47:55PM +0100, Sam Ravnborg wrote:
>Hi Wang.
>> >> >Following untested patch should fix it.
>> >> >
>> >> 
>> >> Still has the same problem. ;(
>> >Could you please doublecheck that you applied the patch and modpost is rebuilt.
>> >If you continue to see the problem could you send me the config (off-list) and
>> >I will fix it.
>> 
>> Sure thing.
>> 
>> I got something like this:
>> 
>>   HOSTCC  scripts/mod/modpost.o
>>   HOSTLD  scripts/mod/modpost
>> 
>> So modpost was rebuilt. And I am quite sure I had applied your patch.
>> 
>> My .config is just the one provided by Toralf. If you need me to send
>> you again, please tell me.
>
>I took Toralf's original config and did a build of latest mainline kernel.
>I got two section mismatch warnings:
>WARNING: vmlinux.o(.text+0x14c8): Section mismatch: reference to .init.data:vsyscall_int80_start (between 'fiddle_vdso' and 'xen_setup_features')
>WARNING: vmlinux.o(.text.head+0x247): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')
>
>Applying the patch I orginally posted fixed the latter of the two.
>The first was fixed by declaring fiddle_vdso __init.
>
>I have tripple chcked that my patch fixes the latter of the two warnings
>and it does. So something is different at your place.
>
>Could you send me the exact warning as you see it.
>

Sorry.

This time the patch is OK. Thanks for your patch!

