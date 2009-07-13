Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbZGMD7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbZGMD7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZGMD7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:59:00 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:61853 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbZGMD7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A6iFvWJMNORXumh9sjbCtc9REt4/+du4h2Iz2xify6tQGCc7XNiMGNX/z8/RriLTeg
         GW4kQz5cAmqCH4M/Ab3ro6u8thEH1JXS5HaZMg4Nqxi1qGzUHzRE2KWN5L1BTOjkSf6X
         pyBMDN2Y9USmBE+QjB8E/YHVRGu1efeFPQ1LE=
MIME-Version: 1.0
In-Reply-To: <4A5A8430.7050300@cn.fujitsu.com>
References: <b9df5fa10907120358t7101511cle30e025c3adcbe54@mail.gmail.com>
	 <4A5A8430.7050300@cn.fujitsu.com>
Date: Mon, 13 Jul 2009 09:58:58 +0600
Message-ID: <b9df5fa10907122058s3edc4c81t670aed7b7160cf82@mail.gmail.com>
Subject: Re: [PATCH] ftrace: Add missing __init in ftrace_profile_debugfs()
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 6:47 AM, Li Zefan<lizf@cn.fujitsu.com> wrote:

> Thanks. It has been fixed by commit
> 9d9949ce45b42be7a8157ea00fff2b1005ed844a in tip tree
>
Ah, sorry for noice.

>> init. Also it contains a trivial style fix, __init should be placed
>> between function type and function name (ftrace_init_debugfs).
>>
>
> I think both styles are Ok.

Yes, but I think we need to be consistent with one style.
>
>
