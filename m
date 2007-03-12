Return-Path: <linux-kernel-owner+w=401wt.eu-S1030720AbXCLRNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030720AbXCLRNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030722AbXCLRNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:13:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030720AbXCLRNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:13:45 -0400
Date: Mon, 12 Mar 2007 13:13:24 -0400
From: Dave Jones <davej@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Stresslinux Kernel <lk@stresslinux.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20.2: kernel BUG at fs/nfs/write.c:505!
Message-ID: <20070312171324.GC22223@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Stresslinux Kernel <lk@stresslinux.org>,
	linux-kernel@vger.kernel.org
References: <45F5582C.1050100@stresslinux.org> <1173718831.6436.30.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173718831.6436.30.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 01:00:31PM -0400, Trond Myklebust wrote:

 > > Code: 0f 0b eb fe f0 ff 41 44 c7 85 18 01 00 00 01 00 00 00 48 8b
 > > RIP  [<ffffffff8032fb83>] nfs_wait_on_requests_locked+0x43/0xb2
 > >  RSP <ffff81007d669ca8>
 > 
 > Known issue. There is already a fix available in the -mm kernel
 > (attached).

Did this get sent to -stable too for .20.3 ?

	Dave

-- 
http://www.codemonkey.org.uk
