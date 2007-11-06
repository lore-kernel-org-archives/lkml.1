Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbXKFGdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbXKFGdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 01:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbXKFGda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 01:33:30 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47201 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753574AbXKFGd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 01:33:29 -0500
Date: Tue, 6 Nov 2007 07:33:05 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106063305.GA26163@stusta.de>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071103164303.GA26707@ubuntu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 06:43:06PM +0200, Ahmed S. Darwish wrote:
> On Fri, Nov 02, 2007 at 01:50:55PM -0700, Casey Schaufler wrote:
> > 
> > Still to come:
> > 
> >   - Final cleanup of smack_load_write and smack_cipso_write.
> 
> Hi All,
> 
> After agreeing with Casey on the "load" input grammar yesterday, here's
> the final grammar and its parser (which needs more testing):
> 
> A Smack Rule in an "egrep" format is:
> 
> "^[:space:]*Subject[:space:]+Object[:space:]+[rwxaRWXA-]+[:space:]*\n"
> 
> where Subject/Object strings are in the form:
> 
> "^[^/[:space:][:cntrl:]]{1,SMK_MAXLEN}$"
>...

Can you limit this to 7bit ASCII and use isascii() somewhere?

Otherwise I'd expect funny things to happen when you e.g. use isspace() 
on the UTF-8 encoded character à.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

