Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYARHWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYARHWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 02:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYARHWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 02:22:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbYARHWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 02:22:16 -0500
Date: Thu, 17 Jan 2008 23:21:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <marcelo@kvack.org>, Rik van Riel <riel@redhat.com>,
       Daniel Spang <daniel.spang@gmail.com>
Subject: Re: [RFC][PATCH] a bit improvement of ZONE_DMA page reclaim
Message-Id: <20080117232147.85ae8cab.akpm@linux-foundation.org>
In-Reply-To: <20080118151822.8FAE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080118151822.8FAE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 15:34:33 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> on X86, ZONE_DMA is very very small.
> It is often no used at all. 

In that case page-reclaim is supposed to set all_unreclaimable and
basically ignores the zone altogether until it looks like something might
have changed.

Is that code not working?  (quite possible).


