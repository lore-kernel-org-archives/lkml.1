Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYK2SxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYK2SxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 13:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYK2Sw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 13:52:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbYK2Sw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 13:52:57 -0500
Date: Sat, 29 Nov 2008 10:51:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
Message-Id: <20081129105120.cfb8c035.akpm@linux-foundation.org>
In-Reply-To: <49318CDE.4020505@redhat.com>
References: <20081128060803.73cd59bd@bree.surriel.com>
	<20081128231933.8daef193.akpm@linux-foundation.org>
	<4931721D.7010001@redhat.com>
	<20081129094537.a224098a.akpm@linux-foundation.org>
	<493182C8.1080303@redhat.com>
	<20081129102608.f8228afd.akpm@linux-foundation.org>
	<49318CDE.4020505@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 13:41:34 -0500 Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> > On Sat, 29 Nov 2008 12:58:32 -0500 Rik van Riel <riel@redhat.com> wrote:
> > 
> >>> Will this new patch reintroduce the problem which
> >>> 26e4931632352e3c95a61edac22d12ebb72038fe fixed?
> 
> No, that problem is already taken care of by the fact that
> active pages always get deactivated in the current VM,
> regardless of whether or not they were referenced.

err, sorry, that was the wrong commit. 
26e4931632352e3c95a61edac22d12ebb72038fe _introduced_ the problem, as
predicted in the changelog.

265b2b8cac1774f5f30c88e0ab8d0bcf794ef7b3 later fixed it up.
