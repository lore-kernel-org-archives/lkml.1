Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYANLlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYANLlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYANLlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:41:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42595 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbYANLlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:41:35 -0500
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
From: Peter Zijlstra <peterz@infradead.org>
To: jplatte@naasa.net
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
In-Reply-To: <200801141230.13694.jplatte@naasa.net>
References: <200801071151.11200.lists@naasa.net>
	 <20080114035439.GA7330@mail.ustc.edu.cn> <400304530.01514@ustc.edu.cn>
	 <200801141230.13694.jplatte@naasa.net>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 12:41:26 +0100
Message-Id: <1200310886.15103.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 12:30 +0100, Joerg Platte wrote:
> Am Montag, 14. Januar 2008 schrieb Fengguang Wu:
> 
> > Joerg, this patch fixed the bug for me :-)
> 
> Fengguang, congratulations, I can confirm that your patch fixed the bug! With 
> previous kernels the bug showed up after each reboot. Now, when booting the 
> patched kernel everything is fine and there is no longer any suspicious 
> iowait!
> 
> Do you have an idea why this problem appeared in 2.6.24? Did somebody change 
> the ext2 code or is it related to the changes in the scheduler?

It was Fengguang who changed the inode writeback code, and I guess the
new and improved code was less able do deal with these funny corner
cases. But he has been very good in tracking them down and solving them,
kudos to him for that work!



