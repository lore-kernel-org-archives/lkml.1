Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbXIBIpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbXIBIpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 04:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXIBIo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 04:44:56 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56515
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754510AbXIBIoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 04:44:55 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
Date: Sun, 2 Sep 2007 03:44:51 -0500
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com> <200708301432.11516.rob@landley.net> <p73lkbqvxp8.fsf@bingen.suse.de>
In-Reply-To: <p73lkbqvxp8.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709020344.51437.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 September 2007 5:16:03 pm Andi Kleen wrote:
> Rob Landley <rob@landley.net> writes:
> > A lot of embedded people like to configure /proc out of the kernel for
> > space reasons.  This would make that noticeably more painful.
>
> I had a patch for a sysctl_name(2) for this a long time ago.
> If it was a serious issue that could be reintroduced.
>
> BTW sysctl(2) only needs to be quiet for a single sysctl used
> by glibc.
>
> -Andi

Yeah, I found it:
http://lkml.org/lkml/2003/7/10/345

I think that if /proc/sys could be broken out as a separate filesystem, and it 
was small and simple, the embedded people would probably be happy.  Is your 
patch significantly smaller than such a filesystem would be?  (Keeping in 
mind that the smallest thing you can do is run from initramfs, and I think 
that's pulling in libfs already...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
