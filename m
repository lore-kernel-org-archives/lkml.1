Return-Path: <linux-kernel-owner+w=401wt.eu-S1423371AbXBHVNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423371AbXBHVNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423389AbXBHVNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:13:42 -0500
Received: from smtp.ono.com ([62.42.230.12]:54365 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423388AbXBHVNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:13:40 -0500
Date: Thu, 8 Feb 2007 22:13:17 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
Message-ID: <20070208221317.5beedaeb@werewolf-wl>
In-Reply-To: <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
	<Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.7.2cvs25 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 11:53:38 -0800 (PST), Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 8 Feb 2007, Jan Engelhardt wrote:
> > 
> > I generally have to agree with you about the unsigned char* vs char*. It 
> > is a problem of the C language that char can be signed and unsigned, and 
> > that people, as a result, have used it for storing 
> > "shorter_than_short_t"s.
> > 
> > What C needs is a distinction between char and int8_t, rendering "char" 
> > an unsigned at all times basically and making "unsigned char" and 
> > "signed char" illegal types in turn.
> 
> No, it's really more fundamental than that.
> 
> Exactly because "char *" doesn't have a defined sign, only a TOTALLY 
> INCOMPETENT compiler will warn about its signedness.
> 

Perhaps the problem is that gcc warns you something like 'if you care
anything about the sign behaviour of what you send to strlen() you're doomed'.
Ie, you declared the var unsigned, so you care about it. But I can do
anything without any regard to the sign.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.19-jam06 (gcc 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #1 SMP PREEMPT
