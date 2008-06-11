Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbYFKKF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbYFKKF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYFKKFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:05:46 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:58425 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbYFKKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:05:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Date: Wed, 11 Jun 2008 12:05:10 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: vegard.nossum@gmail.com, miles.lane@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <200806101637.11473.mb@bu3sch.de> <200806101650.27180.mb@bu3sch.de> <20080611095844J.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080611095844J.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111205.10433.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 02:58:44 FUJITA Tomonori wrote:
> On Tue, 10 Jun 2008 16:50:26 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > On Tuesday 10 June 2008 16:42:41 Vegard Nossum wrote:
> > > This change comes from
> > > 
> > > commit 353c409463ecba63c3a41a992d3f5fba935eada9
> > > Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Date:   Fri May 23 19:02:30 2008 +0000
> > 
> > 
> > Ok, FUJITA Tomonori, please make sure a patch like the following goes
> > into the same trees that you submitted commit 353c409 to.
> > Also make sure to check b43legacy. I _guess_ you might have added
> > the same bug there.
> 
> Ah, sorry about the bug.
> 
> From a quick look, mainline needs the same fix too?
> 
> b43_dma_mapping_error calls unmap_descbuffer() on the failure, which
> assumes that ring->dev is set up properly.

Yeah ok. That's an unlikely error path.
The new bug is in the main path which will always trigger.

Next time please send _any_ patch for review to me and to the wireless list.
Please tell me which trees this bug has been merged to. Is it already in
Linus' tree?

-- 
Greetings Michael.
