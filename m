Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbXLRBrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbXLRBrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758994AbXLRBlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:41:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55618 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763273AbXLRBlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:41:00 -0500
Date: Tue, 18 Dec 2007 10:44:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-kernel@vger.kernel.org
Subject: Re: swapping in 2.6.24-rc5-git3
Message-Id: <20071218104405.2c4d67f7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071218103813.0ee4f159.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071217131726.GA14091@ics.muni.cz>
	<20071218103813.0ee4f159.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 10:38:13 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Is there a way to avoid it except turning off the swap?
> > 
> Maybe...no.
> 
Ah, sorry. If too much dirty page by ftp is trouble, tuning 
/proc/sys/vm/dirty_ratio
/proc/sys/vm/dirty_writeback/centisecs
etc..

may work for you.

Thanks,
-Kame

