Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbZEQAcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbZEQAcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 20:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZEQAcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 20:32:36 -0400
Received: from comar.uludag.org.tr ([193.140.100.220]:36107 "EHLO
	pardus.org.tr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753451AbZEQAcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 20:32:35 -0400
Message-ID: <4A0F5B2A.8010009@pardus.org.tr>
Date: Sun, 17 May 2009 03:32:42 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <alpine.LFD.2.01.0905161644350.3301@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905161644350.3301@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>
> Ok, I'm of two minds on this one.
>
> The thing that triggers it is a module that is both a module _and_ 
> compiled in (ie the same kernel compiled twice, and the stale module kept 
> around). I can see how it happens, and we should react more gracefully to 
> it, but at the same time I can't really bring myself to care deeply.
>   

The patch[0] from Andrew fixed the problem.

Thanks,
Ozan Caglayan

[0]: http://marc.info/?l=linux-kernel&m=124251428228049&w=2

