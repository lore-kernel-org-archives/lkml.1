Return-Path: <linux-kernel-owner+w=401wt.eu-S1946319AbXBPXvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946319AbXBPXvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946321AbXBPXvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:51:22 -0500
Received: from smtp.ono.com ([62.42.230.12]:7882 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946320AbXBPXvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:51:21 -0500
Date: Sat, 17 Feb 2007 00:50:59 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1
Message-ID: <20070217005059.34100823@werewolf-wl>
In-Reply-To: <20070215213006.eeb531cf.akpm@linux-foundation.org>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<20070215223017.2cf5d19f@werewolf-wl>
	<20070215153142.d631f8b7.akpm@linux-foundation.org>
	<20070216003912.238e6ba5@werewolf-wl>
	<20070215213006.eeb531cf.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.7.2cvs46 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 21:30:06 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Nope, can't reproduce (the bug, that is).
> 
> Actually, the oops you have there is the fourth one, so we might be seeing
> downstream effects of oops #1.  Can you please capture the first oops
> trace?  Increasing the log buffer size or using netconsole might help.

Well, forget it. Booting without the nVidia driver makes the oopses go away.
I looks like nvidia is doing something strange with the i2c interface.
D**d closed source drivers...

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.19-jam07 (gcc 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #2 SMP PREEMPT
