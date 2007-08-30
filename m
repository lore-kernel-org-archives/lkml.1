Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbXH3ScW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbXH3ScW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757938AbXH3ScN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:32:13 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38771
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755492AbXH3ScM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:32:12 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
Date: Thu, 30 Aug 2007 14:32:11 -0500
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com> <m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com> <46D4CC81.4060400@zytor.com>
In-Reply-To: <46D4CC81.4060400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301432.11516.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2007 8:31:45 pm H. Peter Anvin wrote:
> Eric W. Biederman wrote:
> > Christoph Hellwig <hch@infradead.org> writes:
> >> Umm, no way we're ever going to remove a syscall like this.
> >
> > If someone besides me cares about more then rhetoric I will be happy
> > to reconsider and several years is plenty of time to find that out.
> >
> > I aborted the removal last time precisely because we had not done an
> > adequate job of warning our users.  A printk when we run a program
> > that uses the binary interface and an long enough interval the warning
> > makes it to the Enterprise kernels before we remove the interface
> > should be sufficient.
>
> glibc uses it, and it uses it in contexts where access to the filesystem
> isn't functional (e.g. in chroot.)

A lot of embedded people like to configure /proc out of the kernel for space 
reasons.  This would make that noticeably more painful.

(If sysctlfs wasn't part of proc, that would be less of an issue, but we need 
union mounts for that...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
