Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbXJ1RAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbXJ1RAE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXJ1Q7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:59:54 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37593 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751121AbXJ1Q7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:59:54 -0400
Date: Sun, 28 Oct 2007 18:00:08 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Kir Kolyshkin <kir@swsoft.com>, containers@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, kir@openvz.org
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
Message-ID: <20071028170008.GD7227@stusta.de>
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com> <m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com> <20071027002448.GH30533@stusta.de> <m18x5puyw7.fsf@ebiederm.dsl.xmission.com> <4724B4F2.7070500@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4724B4F2.7070500@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 09:12:34AM -0700, Jeremy Fitzhardinge wrote:
> Eric W. Biederman wrote:
> > Roughly that sounds like CONFIG_EXPERIMENTAL to me.  But I would
> > be happy to hear if someone has a better idea.
> 
> Rather than overload an existing config option, why not add one with the
> specific semantics you want: CONFIG_UNSTABLE_UABI.  The problem seems
> like one which which may occur again, though one hopes not too often.  I
> guess the risk is that people will leave their subsystems depending on
> it permanently (sysfs?), so it ends up being set all the time and
> becomes as useless as EXPERIMENTAL...

Then let SYSFS depend on UNSTABLE_UABI for the next 10 years and we have 
an excuse for breaking the ABI with each new kernel...

Either the ABI is stable or it should not be exposed to users at all.

>     J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

