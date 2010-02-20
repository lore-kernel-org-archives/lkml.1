Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0BTNso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 08:48:44 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:61900 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab0BTNsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 08:48:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=xXyF1t8QH3fO+qFmocoxFphkXXsLWs4xE6Ae+Ywut60H8lafnSWCgm0tDV8k9vjxg8
         SBVZ9HakWT6oWqMED1RnBTu4nu5/K7gRhXcqr3MQ3a8LdQlF3H95FuGLksr4j47mF18o
         5BYzWuP69PN6u95wia2N3dKGl+/KomF2p/t+s=
Date: Sat, 20 Feb 2010 21:51:22 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: sysfs lockdep complaint
Message-ID: <20100220135122.GB3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net> <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com> <1266664814.11514.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1266664814.11514.5.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 12:20:14PM +0100, Johannes Berg wrote:
>On Sat, 2010-02-20 at 17:26 +0800, Américo Wang wrote:
>> On Thu, Feb 18, 2010 at 5:32 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > Get this when powernowd starts on my G5:
>> >
>> > [   30.490674] =============================================
>> > [   30.490708] [ INFO: possible recursive locking detected ]
>> > [   30.490727] 2.6.33-rc8-wl-64012-g6917413 #160
>> > [   30.490744] ---------------------------------------------
>> > [   30.490763] powernowd/2577 is trying to acquire lock:
>> > [   30.490782]  (s_active){++++.+}, at: [<c0000000001efa94>]
>> .sysfs_addrm_finish+0x58/0xc0
>> > [   30.490831]
>> > [   30.490833] but task is already holding lock:
>> > [   30.490854]  (s_active){++++.+}, at: [<c0000000001eff80>]
>> .sysfs_get_active_two+0x3c/0x84
>> > [   30.490895]
>> 
>> This should be fixed by the patchset from Eric:
>> 
>> http://lkml.org/lkml/2010/2/11/334
>
>Oh wow, well ..... I get like a thousand of these now:
>
>BUG: key c0000002165eb478 not in .data!
>
>instead of the lockdep complaint above.
>

I am not surprised. :)

Please send us the backtraces you got, we could expect this.

Thank you.
