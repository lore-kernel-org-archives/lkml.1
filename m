Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbYFJKhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbYFJKhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYFJKh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:37:28 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:45292 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788AbYFJKh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:37:26 -0400
X-Greylist: delayed 1018 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2008 06:37:26 EDT
From: Grant Coady <grant_lkml@dodo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.26-rc5-mm2 lockup up on Intel G33+ICH9R+Core2Duo, -mm1 okay
Date: Tue, 10 Jun 2008 20:20:09 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <73ls44tntnv8ro57chp1on2crsqkoilmkj@4ax.com>
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
In-Reply-To: <20080609223145.5c9a2878.akpm@linux-foundation.org>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 22:31:45 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:

>
>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/
>
>- This is a bugfixed version of 2.6.26-rc5-mm1 - mainly to repair a
>  vmscan.c bug which would have prevented testing of the other vmscan.c
>  bugs^Wchanges.

No it's not :)

-mm1 worked fine here but -mm2 locks up just after saying:
agpgart: Detected 7164K stolen memory.

Nothing in logs (session not recorded - hit reset to restart).

config and dmseg for -mm1 at (same .config for mm2):

  http://bugsplatter.mine.nu/test/boxen/pooh/config-2.6.26-rc5-mm1a.gz
  http://bugsplatter.mine.nu/test/boxen/pooh/dmesg-2.6.26-rc5-mm1a.gz

Grant.
