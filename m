Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbXHLI6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbXHLI6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 04:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758497AbXHLI6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 04:58:14 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:51542 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752943AbXHLI6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 04:58:13 -0400
Message-ID: <386909088.16432@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 12 Aug 2007 16:58:08 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070812085808.GA7239@mail.ustc.edu.cn>
Mail-Followup-To: Balbir Singh <balbir@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <386838491.27058@ustc.edu.cn> <661de9470708110730r1267bdfdp1e76546e11b64f78@mail.gmail.com> <20070811100015.2417788e.akpm@linux-foundation.org> <46BDF965.3050402@linux.vnet.ibm.com> <20070812054831.GB8992@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812054831.GB8992@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 01:48:31PM +0800, WU Fengguang wrote:
> On Sat, Aug 11, 2007 at 11:31:09PM +0530, Balbir Singh wrote:
> > Andrew Morton wrote:
> > > On Sat, 11 Aug 2007 20:00:12 +0530 "Balbir Singh" <balbir@linux.vnet.ibm.com> wrote:
> > >>>
> > >> Shouldn't we just not stop vm accounting for kernel threads?
> > >>
> > > 
> > > Could be.  It'd help heaps if we knew which patch in -mm caused
> > > this, but from a quick peek it seems to me that mainline should be
> > > vulnerable as well.
> > 
> > Thats a valid point. It would be interesting to see what the overcommit
> > setting was, when the panic occurred.
> 
> FYI, I do have nondefault overcommit settings:
> 
> vm.overcommit_memory = 2
> vm.lowmem_reserve_ratio = 1 1

Yes, the bug disappears when changing to default overcommit_memory!

