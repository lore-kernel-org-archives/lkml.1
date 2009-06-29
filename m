Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZF2TAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZF2TAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZF2TAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:00:22 -0400
Received: from lider.uludag.org.tr ([193.140.100.216]:41135 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZF2TAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:00:22 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jun 2009 15:00:21 EDT
Message-ID: <4A490D47.7030305@pardus.org.tr>
Date: Mon, 29 Jun 2009 21:51:51 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>, intel-gfx@lists.freedesktop.org,
       woodys@xandros.com, stefan.bader@canonical.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       Jesse Barnes <jbarnes@virtuousgeek.org>, apw@canonical.com,
       tim.gardner@canonical.com, torvalds@linux-foundation.org,
       stable@kernel.org
Subject: Re: [stable] [Intel-gfx] Intel 915GM MCHBAR bug
References: <4A242C81.6020906@cs.helsinki.fi> <4A298971.5080006@xandros.com> <4A2A0951.1020608@cs.helsinki.fi> <20090605232711.d8503262.akpm@linux-foundation.org> <4A2A0E8C.1010109@cs.helsinki.fi> <20090606212759.31970fae@jbarnes-x200> <20090609150757.4a2109a9@jbarnes-x200> <20090609152828.d82528f3.akpm@linux-foundation.org> <20090629173308.GB3901@kroah.com> <20090629182738.GD3901@kroah.com>
In-Reply-To: <20090629182738.GD3901@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I take it back.  It doesn't build properly on 2.6.30, can someone
> backport commit d765898970f35acef960581f678b9da9d5c779fa to the 2.6.30
> tree and send it to stable@kernel.org so that we can apply it to resolve
> this issue?
> ease read the FAQ at  http://www.tux.org/lkml/
>   

There was this commit on top of them which was fixed the build problem
for me:
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fanholt%2Fdrm-intel.git;a=commitdiff_plain;h=34c8638bb5ee130b8151c57708284bcd4972e2e1;hp=003c9ca68810bc0a63a1f3ff6beec839b197e23b
