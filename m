Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbXJBKrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbXJBKrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXJBKrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:47:40 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:38499 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751924AbXJBKrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:47:40 -0400
Message-ID: <391322057.11200@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 2 Oct 2007 18:47:34 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Message-ID: <20071002104734.GA9410@mail.ustc.edu.cn>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <1191313025.13204.30.camel@twins> <20071002013148.18958af2.akpm@linux-foundation.org> <1191314911.13204.41.camel@twins> <3ae72650710020331o2ce5bd20wccc1964855279796@mail.gmail.com> <1191321861.13204.53.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191321861.13204.53.camel@twins>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 12:44:21PM +0200, Peter Zijlstra wrote:
> On Tue, 2007-10-02 at 12:31 +0200, Kay Sievers wrote:
> 
> > What would be the point in another top-level tree for device
> > information? All devices you are exporting information for, are
> > already in the sysfs tree, right?
> 
> Never did find NFS mounts/servers/superblocks or whatever constitutes a
> BDI for NFS in there. Same goes for all other networked filesystems for
> that matter.

And loop/md/dm devices...

