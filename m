Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbZF3OqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbZF3OqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZF3Opx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:45:53 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:49661 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbZF3Opx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:45:53 -0400
Date: Tue, 30 Jun 2009 15:45:40 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [BUG] MIPS: Hibernation in the latest linux-mips:master branch
	not work
Message-ID: <20090630144540.GA18212@linux-mips.org>
References: <1246372868.19049.17.camel@falcon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246372868.19049.17.camel@falcon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 10:41:08PM +0800, Wu Zhangjin wrote:

> I just updated my git repository to the master branch of the latest
> linux-mips git repository, and tested the STD/Hibernation support on
> fuloong2e and yeeloong2f, it failed:
> 
> when using the no_console_suspend kernel command line to debug, it
> stopped on:
> 
> PM: Shringking memory... done (1000 pages freed)
> PM: Freed 160000 kbytes in 1.68 seconds (95.23 MB/s)
> PM: Creating hibernation image:
> PM: Need to copy 5053 pages
> PM: Hibernation image created (4195 pages copied)
> 
> and then, the number indicator light of keyboard works well, but can not
> type anything. 
> 
> anybody have tested it on another platform? does it work?

At the time of the merge I tested it on Malta and found it to be working.

  Ralf
