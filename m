Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYC3XuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYC3XuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbYC3Xt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:49:59 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50570 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbYC3Xt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:49:58 -0400
Date: Mon, 31 Mar 2008 01:49:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Gene Heskett <gene.heskett@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: MCE going wild, 14 megs of this in the logs
In-Reply-To: <200803301657.53232.gene.heskett@gmail.com>
Message-ID: <Pine.LNX.4.64.0803310148540.32241@twin.jikos.cz>
References: <200803301657.53232.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008, Gene Heskett wrote:

> Mar 30 16:46:42 coyote kernel: [469249.031832] MCE: The hardware reports a non 
> fatal, correctable incident occurred on CPU 0.
> Mar 30 16:46:42 coyote kernel: [469249.031838] Bank 1: d400400000000152
> Mar 30 16:46:42 coyote kernel: [469249.031841] MCE: The hardware reports a non 
> fatal, correctable incident occurred on CPU 0.
> Mar 30 16:46:42 coyote kernel: [469249.031844] Bank 2: d40040000000017a
> Its always the same 2 addresses reported, and every 15 seconds.  So I have the 
> non-fatal part of MCE now turned off, & 2.6.24.4 rebuilding.

Hi,

you possible have some buggy hardware. I'd suggest running this through 
mcelog, which should decode the MCE reason.

-- 
Jiri Kosina
SUSE Labs

