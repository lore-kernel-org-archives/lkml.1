Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbYDCOtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbYDCOtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757603AbYDCOsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:48:54 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56635 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757329AbYDCOsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:48:54 -0400
Date: Thu, 3 Apr 2008 10:48:52 -0400
To: "Andreas K. Huettel" <mail@akhuettel.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [tainted,fglrx] page allocation failure: basic meaning of log messages?
Message-ID: <20080403144852.GD24239@csclub.uwaterloo.ca>
References: <alpine.LNX.1.00.0804031117030.10277@localhost> <20080403183021.028C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.LNX.1.00.0804031318480.10277@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0804031318480.10277@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 01:22:40PM +0200, Andreas K. Huettel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: RIPEMD160
> 
> 
> Hi, 
> 
> #]> Apr  3 09:01:30 bellini hal-system-powe: page allocation failure. order:10, mode:0x4020
> #]> Apr  3 09:01:30 bellini Pid: 327, comm: hal-system-powe Tainted: PF       2.6.24-gentoo-r3 #1
> #]> Apr  3 09:01:30 bellini [<c0140c48>] __alloc_pages+0x2bd/0x2ce
> #]> Apr  3 09:01:30 bellini [<c0140c92>] __get_free_pages+0x39/0x47
> #]> Apr  3 09:01:30 bellini [<f8adcd9e>] firegl_cmmqs_save_fb+0x8e/0x200 [fglrx]
> #]
> #]this messages doesn't mean bug, merely indicate allocation failure.
> #]if any other bad thind doen't happend, you can ignore it.
> 
> Swapping like mad without any obvious cause (500M swap in use, 1.5G RAM 
> - - which is normally not such a big problem). This however stopped when 
> I closed some memory-intensive applications (firefox, vmware).
> 
> Since then the machine is running without problems. 

firefox 2.x tends to leak memory like crazy in my experience, so it may
be perfectly normal.  If you have adobe's flash plugin firefox can leak
very quickly too.

-- 
Len Sorensen
