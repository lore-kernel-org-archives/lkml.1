Return-Path: <linux-kernel-owner+w=401wt.eu-S934870AbZDHRas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934870AbZDHRas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934487AbZDHRaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:30:16 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:37288 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934550AbZDHRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:30:13 -0400
Date: Wed, 8 Apr 2009 13:30:07 -0400
From: Woody Suwalski <woodys@xandros.com>
To: Chris Howie <cdhowie@gmail.com>
cc: linux-kernel@vger.kernel.org
Message-ID: <49DCDF1F.5050805@xandros.com>
In-Reply-To: <3d2f29dc0904071551xadea34ajd2c177380ced4fef@mail.gmail.com>
References: <3d2f29dc0904071551xadea34ajd2c177380ced4fef@mail.gmail.com>
Subject: Re: Weird freezes with 2.6.28/29
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Howie wrote:
> Hello everyone.
>
> I've been running across some bizarre and obnoxious freezes on 2.6.28
> and 2.6.29.  I will describe my problem and attach an annotated kernel
> log indicating where each problem happens.
>
> Upon initial boot, everything seems to be going fine.  But early on
> the entire system freezes.  The only reliable way I've found to
> unfreeze it is to press the power button on my laptop.
>
> After that, the system will either boot fine or freeze again later.
> If it does freeze, it's when init is starting all my services.  Most
> of the time it freezes while starting resolvconf.  (I don't /think/
> that's significant, but who knows.)  I can unfreeze it by holding down
> pretty much any key on the keyboard.  I usually use CTRL since it
> doesn't spam the console, but any key works.  The moment I release the
> key, it freezes again.  Once X starts up there are no more freezing
> problems.  But then it happens again on shutdown.  I have to hold a
> key until the laptop powers off or it will freeze while init is
> killing services.
>
> Aside from some hibernate flakiness that I have come to expect, these
> are the only problems I'm having with this kernel version.  Is there
> any additional information I can supply that will facilitate proper
> debugging of this problem?
>
> Thanks!
>
>   
I am getting similar problem on Dell 4x00 laptops caused by loading 
processor.ko.
If I use nocst=1 option, systems are OK.

Woody

-- 
Woody Suwalski, Xandros, Ottawa, Canada, 1-613-842-3498 x414


