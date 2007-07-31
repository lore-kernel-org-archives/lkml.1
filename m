Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbXGaMIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbXGaMIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXGaMH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:07:58 -0400
Received: from styx.suse.cz ([82.119.242.94]:36072 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751598AbXGaMH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:07:57 -0400
Date: Tue, 31 Jul 2007 14:19:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, Jan Kratochvil <honza@jikos.cz>,
       jakub@redhat.com
Subject: Re: Is PIE randomization breaking klibc binaries?
In-Reply-To: <46AF24B2.8070900@zytor.com>
Message-ID: <Pine.LNX.4.64.0707311418040.26532@jikos.suse.cz>
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com>
 <46A6624E.60003@redhat.com> <46A667BD.5080106@redhat.com>
 <20070724220053.GA20531@deine-taler.de> <46A68003.6060901@redhat.com>
 <46A68118.9080902@zytor.com> <20070725063243.GA25148@deine-taler.de>
 <Pine.LNX.4.64.0707311326090.26532@jikos.suse.cz> <46AF24B2.8070900@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007, H. Peter Anvin wrote:

> > I just now quickly tried to with klibc-1.5 on i386 with the 
> > PIE-randomization patched kernel, and it seems to load static 
> > libraries fine. I just downloaded klibc-1.5, built it, and executed a 
> > few of the programs in usr/utils/static, all of them worked. Does this 
> > also work for you and you are experiencing the problems solely when 
> > the binaries are being run from initramfs during boot? I will test 
> > more shortly (on x86_64, directly from initramfs) in order to 
> > reproduce.
> What about shared binaries?

Works for me too on the pie-randomization patched kernel.

So it seems to me that either it is something x86_64 specific or 
initramfs-specific. Will try to reproduce it.

-- 
Jiri Kosina
SUSE Labs
