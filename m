Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZHTCf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZHTCf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZHTCf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:35:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53038 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbZHTCf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:35:58 -0400
Message-ID: <4A8CB62F.8030504@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 10:34:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/8] Revert commit 8827c288feb7810185aa7c2e37537202fc709869
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235812.22531.76212.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090818235812.22531.76212.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Revert commit 8827c288feb7810185aa7c2e37537202fc709869
> 
> This is in preparation for some clashing cgroups changes that subsume
> the original commit's functionaliy.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> --
> 
> The original commit fixed a pid namespace bug which Ben Blum fixed
> independently (in the same way, but with different code) as part of a
> series of patches. I played around with trying to reconcile Ben's
> patch series with Li's patch, but concluded that it was simpler to
> just revert Li's, given that Ben's patch series contained essentially
> the same fix.
> 

It's sure that reverting this commit makes things easier, but
rebasing this patchset shouldn't be hard. And this doesn't
sound a good reason to revert an innocent commit.

