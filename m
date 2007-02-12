Return-Path: <linux-kernel-owner+w=401wt.eu-S965082AbXBLR7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082AbXBLR7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965086AbXBLR7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:59:34 -0500
Received: from lazybastard.de ([212.112.238.170]:38199 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964926AbXBLR7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:59:32 -0500
Date: Mon, 12 Feb 2007 17:55:26 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Dave Jones <davej@redhat.com>, Valerie Henson <val_henson@linux.intel.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>, val_henson@linux.interl.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting MS_RELATIME
Message-ID: <20070212175526.GC2112@lazybastard.org>
References: <45CE0737.6010103@gmx.net> <20070211005400.GC6849@redhat.com> <20070212065503.GC20919@nifty> <20070212154010.GC7617@redhat.com> <Pine.LNX.4.61.0702121848480.26360@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0702121848480.26360@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 February 2007 18:49:39 +0100, Jan Engelhardt wrote:
> On Feb 12 2007 10:40, Dave Jones wrote:
> >
> >The one problem with noatime is that mutt's 'new mail arrived' breaks
> 
> Just why does not it use mtime then to check for New Mail Arrived, like 
> bash does?

Just a guess: because it has to compare the time?

Bash can simply compare mtime of (single) mailbox with time of last
login.  Mutt would have to compare mtime of (many) mailboxes with...
I believe with atime of mailboxes.

Jörn

-- 
Joern's library part 1:
http://lwn.net/Articles/2.6-kernel-api/
