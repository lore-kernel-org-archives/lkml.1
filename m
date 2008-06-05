Return-Path: <linux-kernel-owner+w=401wt.eu-S1762974AbYFECaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974AbYFECaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 22:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYFECaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 22:30:05 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:32477 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYFECaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 22:30:04 -0400
Date: Wed, 4 Jun 2008 19:30:02 -0700
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       kobayashi.kk@ncos.nec.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] per-task-delay-accounting: /proc export for memory
 reclaim delay
Message-Id: <20080604193002.b9e6054e.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080604154124.5b5b5bf7.akpm@linux-foundation.org>
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
	<20080603194608.ed76ecf3.kobayashi.kk@ncos.nec.co.jp>
	<20080604120235.940B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080604154124.5b5b5bf7.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 15:41:24 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Any application which breaks if we add more things to /proc/pid/stat
> just needs to be fixed.
> 
> But we can't add new fields in the middle of the line!  We can only add
> new items to the end.
> 
> But I think it would be good if we just weren't to make this change. 
> Do we really want to keep reporting the same information in two
> separate ways?

I agree. There is no strong reason with two method.
I'll drop this one from patch series next time.

