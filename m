Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbZKDX7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbZKDX7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932703AbZKDX7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:59:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758032AbZKDX7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:59:02 -0500
Date: Wed, 4 Nov 2009 15:57:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Yannick Roehlly <yannick.roehlly@free.fr>,
       Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jesse.barnes@intel.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>, berndl81@gmx.at,
       Greg KH <greg@kroah.com>
Subject: Re: Reverting 5d423 fixes loading of ath9k on Acer Extensa 7630EZ
In-Reply-To: <43e72e890911041540hd1e5f87u8d282d9c95857504@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0911041551220.31845@localhost.localdomain>
References: <43e72e890911041540hd1e5f87u8d282d9c95857504@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Nov 2009, Luis R. Rodriguez wrote:
> 
> Can you please consider reviewing this issue and help determine if
> this indeed needs to be reverted for 2.6.32 and the next 2.6.31.y.
> 
> I am curious if other devices would work by reverting this as well.
> [ ... ] For details please feel free to check:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=14402

That same commit was the cause for

	http://bugzilla.kernel.org/show_bug.cgi?id=13940

and we just increased the rounding to make it go away (see commit 
15b812f1). But that was a hack.

And if that didn't help the ath9k case, then we should just revert 
entirely.

			Linus
