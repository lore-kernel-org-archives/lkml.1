Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbXKZHDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbXKZHDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 02:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbXKZHDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 02:03:25 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58522 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbXKZHDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 02:03:24 -0500
Date: Mon, 26 Nov 2007 16:06:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: kosaki <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1 (sync is slow ?)
Message-Id: <20071126160635.015ca748.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <474867B2.4080809@googlemail.com>
References: <20071121174215.caff4551.kamezawa.hiroyu@jp.fujitsu.com>
	<20071121004909.6157bb9a.akpm@linux-foundation.org>
	<20071124190604.276B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<474867B2.4080809@googlemail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007 19:04:34 +0100
Gabriel C <nix.or.die@googlemail.com> wrote:
> >> It seems OK here from a quick test (i386, ext3-on-IDE).
> >>
> >> Maybe device driver/block breakage?
> 
> Try revert
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff_plain;h=8655a546c83fc43f0a73416bbd126d02de7ad6c0;hp=5bc717b6bdaaf52edf365eb7d9d8c89fec79df5d
> 
> See also :
> http://lkml.org/lkml/2007/11/23/5
> 
> and search for '2.6.24-rc3-mm1: I/O error, system hangs' on LKML
> 

Thank you!
The problem was fixed by reverting the patch you pointed out.

-Kame

