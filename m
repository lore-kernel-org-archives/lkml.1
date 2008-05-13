Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbYEMUcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbYEMUcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758671AbYEMUc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:32:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758337AbYEMUc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:32:26 -0400
Date: Tue, 13 May 2008 13:28:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 25/37] sparc: Fix mremap address range validation.
In-Reply-To: <20080513201229.GZ31167@suse.de>
Message-ID: <alpine.LFD.1.10.0805131327130.3019@woody.linux-foundation.org>
References: <20080513200453.064446337@mini.kroah.org> <20080513201229.GZ31167@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 May 2008, Greg KH wrote:
>
> From: David S. Miller <davem@davemloft.net>
> 
> Just like mmap, we need to validate address ranges regardless
> of MAP_FIXED.

Hmm. I don't have this one in my tree. Is it obsoleted by the other 
patches I do have, or what? If so, some comment about that would be nice.

		Linus
