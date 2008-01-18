Return-Path: <linux-kernel-owner+w=401wt.eu-S1762968AbYARQQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762968AbYARQQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762783AbYARQQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:16:24 -0500
Received: from ag-out-0708.google.com ([72.14.246.248]:61045 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760537AbYARQQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:16:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=kaxHJnXdh/QCW8vaARlwJGYtkmKJ32OipowftFV39i3Ok9V4wJnAUNjpRiCFBvsAhC1B8/2m7NU61ILruM+aS/i6tZxYVrNqG1nGj4qQqkS79XxJBaky5BYo/Chaqt6VH1I88aOQTrVzxuk7nJdSm6AbAFq0SqygFmHYqtneMyk=
Date: Sat, 19 Jan 2008 00:14:52 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: build #343 issue for v2.6.24-rc8-29-g03bbe08 : Section
	mismatch: reference to .init.text.1:start_kernel (between 'is386'
	and 'check_x87')
Message-ID: <20080118161452.GJ2559@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200801181318.30009.toralf.foerster@gmx.de> <20080118122917.GH2559@hacking> <20080118124627.GA17918@uranus.ravnborg.org> <20080118125144.GI2559@hacking> <20080118132242.GA18183@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080118132242.GA18183@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 02:22:42PM +0100, Sam Ravnborg wrote:
>On Fri, Jan 18, 2008 at 08:51:44PM +0800, WANG Cong wrote:
>> On Fri, Jan 18, 2008 at 01:46:27PM +0100, Sam Ravnborg wrote:
>> >On Fri, Jan 18, 2008 at 08:29:17PM +0800, WANG Cong wrote:
>> >> On Fri, Jan 18, 2008 at 01:18:27PM +0100, Toralf Förster wrote:
>> >> >Hello,
>> >> >
>> >> >the build with the attached .config was successful however I got during make :
>> >> >  AS      .tmp_kallsyms2.o
>> >> >  LD      vmlinux.o
>> >> >  MODPOST vmlinux.o
>> >> >WARNING: vmlinux.o(.text.head+0x247): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')
>> >> >  CHK     include/linux/version.h
>> >> >  HOSTCC  scripts/unifdef
>> >> >  MKDIR   include
>> >> >
>> >> >Does it help / make sense to report such warning ?
>> >> >
>> >> >The build was made with :
>> >> >$> make mrproper && make rndconfig && <tweak config file> && make oldconfig && make
>> >> >
>> >> >Here's the config:
>> >> 
>> >> Thanks. You have reported this. ;)
>> >> 
>> >> I can't solve this problem. Let's Cc Rusty and Sam to see
>> >> if they can solve this.
>> >
>> >modpost gets confused by the section named ".init.text.1" - the additional '.1'
>> >is unexpected.
>> >
>> >Following untested patch should fix it.
>> >
>> 
>> Still has the same problem. ;(
>Could you please doublecheck that you applied the patch and modpost is rebuilt.
>If you continue to see the problem could you send me the config (off-list) and
>I will fix it.

Sure thing.

I got something like this:

  HOSTCC  scripts/mod/modpost.o
  HOSTLD  scripts/mod/modpost

So modpost was rebuilt. And I am quite sure I had applied your patch.

My .config is just the one provided by Toralf. If you need me to send
you again, please tell me.

