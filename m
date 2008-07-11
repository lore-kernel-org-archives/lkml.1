Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbYGKTZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbYGKTZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759933AbYGKTWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:22:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758542AbYGKTWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:22:20 -0400
Date: Fri, 11 Jul 2008 12:21:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
Message-Id: <20080711122131.b6461ab1.akpm@linux-foundation.org>
In-Reply-To: <20080708145051.GA14745@redhat.com>
References: <1215401122.4660.4.camel@caritas-dev.intel.com>
	<20080708145051.GA14745@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 10:50:51 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Jul 07, 2008 at 11:25:22AM +0800, Huang Ying wrote:
> > This patch provides an enhancement to kexec/kdump. It implements
> > the following features:
> > 
> > - Backup/restore memory used by the original kernel before/after
> >   kexec.
> > 
> > - Save/restore CPU state before/after kexec.
> > 
> 
> Hi Huang,
> 
> In general this patch set looks good enough to live in -mm and
> get some testing going.
> 
> To me, adding capability to return back to original kernel looks
> like a logical extension to kexec functionality.

Exciting ;)  It's much less code than I expected.

I don't think I understand the feature any more.  Once upon a time we
thought that this might become a new and better (or at least
better-code-sharing) way of doing suspend-to-disk.  How far are we from
that?

What are the prospects of supporting other architectures?

Who maintains kexec-tools, and are they OK with merging up the
corresponding changes?

Thanks.
