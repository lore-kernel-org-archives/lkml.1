Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbYFDELv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbYFDELv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbYFDELo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:11:44 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:43012 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYFDELn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:11:43 -0400
Date: Tue, 3 Jun 2008 21:11:42 -0700
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/4] per-task-delay-accounting: /proc export for memory
 reclaim delay
Message-Id: <20080603211142.c0977893.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080604120235.940B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
	<20080603194608.ed76ecf3.kobayashi.kk@ncos.nec.co.jp>
	<20080604120235.940B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2008 12:07:29 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> ----------------------------------------
> #!/usr/bin/perl
> 
> $stat = `cat /proc/$pid/stat`;
> split
> @stat_list = split(/ / , $stat);
> print stat_list[$index];
>                  ^
>                  |
>                  use array index number

Certainly, it makes sense.
I thought this measurement value should be put
beside other delay account.
