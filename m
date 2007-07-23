Return-Path: <linux-kernel-owner+w=401wt.eu-S933968AbXGWSJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968AbXGWSJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763362AbXGWSJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:09:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:26758 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763278AbXGWSJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kB2CMBWg2tIHS/iH9vOl6QZ+t6fHx25xKwLl/F170H+z4qKCARFE/P0SWHLENzFkWSdCgUlhSZrEikijOI5V5Cg0ARk0gIhdhz/Kj7Y7ap2WZoWY8h1PJ33zdfLZCjGh9g9p0mS7m9Y52boW2Yz2phLt+gR8z5dKvRHGgi43T1w=
Message-ID: <a4e6962a0707231109r332e8d8ft791c947b421ead0e@mail.gmail.com>
Date: Mon, 23 Jul 2007 13:09:18 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Latchesar Ionkov" <lucho@ionkov.net>
Subject: Re: CTL_UNNUMBERED (Re: [PATCH] 9p: Don't use binary sysctl numbers.)
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <f158dc670707231105o18fa3f63j194285547493f04a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m1y7h9wpuo.fsf@ebiederm.dsl.xmission.com>
	 <20070721205709.GB5772@martell.zuzino.mipt.ru>
	 <m1odi5wfjg.fsf@ebiederm.dsl.xmission.com>
	 <a4e6962a0707231013v47683cd0xd35c65c25cb40653@mail.gmail.com>
	 <f158dc670707231105o18fa3f63j194285547493f04a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/07, Latchesar Ionkov <lucho@ionkov.net> wrote:
> It doesn't really matter (for me) whether it is sysctl or sysfs
> interface. The sysctl approach seemed easier to implement. If the
> consensus is to use sysfs, I'll send a patch (for 2.6.24).
>
> Sorry for the incorrect implementation, I guess I stole the code from
> unappropriate place :)
>

I think this is appropriate for a "fix" submission to the 2.6.23-rc
series.  If you don't have the bandwidth right now, I'll look at
reworking it, or at the very least just removing the sysctl interface.

         -eric
