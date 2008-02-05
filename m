Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYBEFxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYBEFxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 00:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYBEFx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 00:53:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbYBEFx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 00:53:28 -0500
Date: Mon, 4 Feb 2008 21:53:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Igor M Podlesny <for.poige+linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: > You may find that you need to update your lvm userspace
 tools.
Message-Id: <20080204215304.8b909402.akpm@linux-foundation.org>
In-Reply-To: <47A7F4DB.3070406@gmail.com>
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>
	<20080202235103.20dd9768.akpm@linux-foundation.org>
	<47A71040.5000300@gmail.com>
	<20080204052709.12f4e0d3.akpm@linux-foundation.org>
	<47A7F4DB.3070406@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 12:32:11 +0700 Igor M Podlesny <for.poige+linux@gmail.com> wrote:

> On 2008-02-04 20:27, Andrew Morton wrote:
> > On Mon, 04 Feb 2008 20:16:48 +0700 Igor M Podlesny <for.poige+linux@gmail.com> wrote:
> [...]
> >>    Now I can say that both 2.6.24-mm1 and 2.6.24-git11 do NOT "see" any
> >> of mine LVM-2 disks. pvscan, for e.g., finds nothing at all.
> > 
> > You may find that you need to update your lvm userspace tools.
> 
> 	You're right; I've updated my initrd with fresh lvm
> userspace-counterpart and now the problem has been fixed. Sorry for
> groundless alert.
> 

No, breakage of a userspace interface is considered a serious regression.

If this was deliberate and utterly unavoidable, well, that's bad but sometimes
these things happen.  We do prefer to go through elaborate notification
processes to minimise the disruption, which afaik did not happen here.

If, however, the breakage was was unintentional then we should find the
cause and fix it asap, and backport the fix into 2.6.24.1.

Please tell us what version of the userspace tools you were previously runnning.

Could someone in dm-devel land please get involved?
