Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbYC0HYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbYC0HYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 03:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYC0HYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 03:24:00 -0400
Received: from sacred.ru ([62.205.161.221]:56396 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYC0HX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 03:23:59 -0400
Message-ID: <47EB4AB4.7070704@openvz.org>
Date: Thu, 27 Mar 2008 10:20:20 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow to ptrace /sbin/init
References: <20080326201623.GA131@tv-sign.ru>
In-Reply-To: <20080326201623.GA131@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 27 Mar 2008 10:20:18 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Afaics, currently there are no kernel problems with ptracing init, it can't
> lose SIGNAL_UNKILLABLE flag and be killed/stopped by accident.
> 
> The ability to strace/debug init can be very useful if you try to figure
> out why it does not work as expected.
> 
> However, admin should know what he does, "gdb /sbin/init 1" stops init, it
> can't reap orphaned zombies or take care of /etc/inittab until continued.
> It is even possible to crash init (and thus the whole system) if you wish,
> ptracer has full control.
> 
> See also the long discussion: http://marc.info/?t=120628018600001
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Pavel Emelyanov <xemul@openvz.org>
