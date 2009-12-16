Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbZLPWs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbZLPWs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762668AbZLPWsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:48:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761616AbZLPWr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:47:59 -0500
Date: Wed, 16 Dec 2009 14:47:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] VFS stuff, part 1
In-Reply-To: <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0912161444470.3556@localhost.localdomain>
References: <20091216185157.GL14381@ZenIV.linux.org.uk> <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Alexander Beregalov wrote:
> 
> Is it obvious for you or do I need to bisect ?

It might be obvious to Al, but it would be good to bisect it anyway, just 
in case. Since you now have a fairly tight range of commits, it shouldn't 
be _too_ bad.

[ My main desktop is running that bac5e54 kernel that you have as bad 
  right noe, so it's not something totally obviously broken. Maybe it 
  needs btrfs or something else specific to trigger. ]

		Linus
