Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZAVFj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZAVFj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 00:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbZAVFjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 00:39:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:30228 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZAVFjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 00:39:47 -0500
MIME-Version: 1.0
In-Reply-To: <200901221043.13684.knikanth@suse.de>
References: <200901211638.23101.knikanth@suse.de>
	 <20090122122843.7e94878e.kamezawa.hiroyu@jp.fujitsu.com>
	 <200901221043.13684.knikanth@suse.de>
Date: Wed, 21 Jan 2009 21:39:45 -0800
Message-ID: <d6200be20901212139u3683c829x4db1840a28986a6f@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, Chris Snook <csnook@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Menage <menage@google.com>,
       containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 9:13 PM, Nikanth Karthikesan <knikanth@suse.de> wrote:
> To use oom_adj effectively one should continuously monitor oom_score of all
> the processes, which is a complex moving target and keep on adjusting the
> oom_adj of many tasks which still cannot guarantee the order. This controller
> is deterministic and hence easier to use.
>

Why not add an option to make oom_adj ensure strict ordering instead?

-- 
Arve Hjønnevåg
