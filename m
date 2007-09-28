Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbXI1BTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbXI1BTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 21:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759216AbXI1BSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 21:18:52 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:46409 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757639AbXI1BSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 21:18:52 -0400
Message-ID: <390942329.08474@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 28 Sep 2007 09:18:46 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kumar Gala <galak@kernel.crashing.org>,
       Pete Zaitcev <zaitcev@redhat.com>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: remove unnecessary wait in
	throttle_vm_writeout()
Message-ID: <20070928011846.GA5496@mail.ustc.edu.cn>
References: <390857819.00313@ustc.edu.cn> <20070927111610.68584fdd@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927111610.68584fdd@bree.surriel.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 11:16:10AM -0400, Rik van Riel wrote:
> On Thu, 27 Sep 2007 09:50:16 +0800
> Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > We don't want to introduce pointless delays in throttle_vm_writeout()
> > when the writeback limits are not yet exceeded, do we?
> 
> Good catch.

Thank you.
 
> > Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>

It could be a good fix for 2.6.22/23.  But for -mm, I'm not
sure if throttle_vm_writeout() will be eventually removed ;-)

