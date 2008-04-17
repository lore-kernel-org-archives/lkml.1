Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbYDQOT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbYDQOT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYDQOTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:19:20 -0400
Received: from lazybastard.de ([212.112.238.170]:58454 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbYDQOTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:19:19 -0400
Date: Thu, 17 Apr 2008 16:19:11 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Smartmedia/xd card support - request for comments
Message-ID: <20080417141911.GB30001@logfs.org>
References: <466372.69780.qm@web36702.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <466372.69780.qm@web36702.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 April 2008 01:50:33 -0700, Alex Dubov wrote:
> 
> Current version will always issue whole block writes (no individual page programming). I,in fact,
> implemented a version which tracks partially filled blocks, but experiments with some Olympus xd
> cards triggered a lot of funny hardware problems with this, and then, it appeared that latest
> version of xd card spec specifically disallows partial block writes.

drivers/mtd/nand/alauda.c already does page writes.  You didn't know the
existing wheel and invented new one.  That happens and there is nothing
wrong with it.

Your chances of merging your new code as-is are roughly zero.  But I
would still like to see the code and see where yours is better and ours
should be improved.  Or you could take a look yourself and send patches.

> MemoryStick spec does allow individual page writes, but so did an older version of xd card spec.
> Given this, I decided to start with simpler version of FTL for now and replace it with a more
> complex one if need arises.

Are Memory Sticks covered by your code?  That would be a worthwhile
improvement.

Jörn

-- 
Joern's library part 3:
http://inst.eecs.berkeley.edu/~cs152/fa05/handouts/clark-test.pdf
