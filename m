Return-Path: <linux-kernel-owner+w=401wt.eu-S933000AbZHVAIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbZHVAIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 20:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932726AbZHVAID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 20:08:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624AbZHVAIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 20:08:01 -0400
Date: Fri, 21 Aug 2009 17:06:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, nhorman@redhat.com, ebiederm@xmission.com,
       kamezawa.hiroyu@jp.fujitsu.com, andi@firstfloor.org, amwang@redhat.com,
       bernhard.walle@gmx.de, fenghua.yu@intel.com, mingo@elte.hu,
       avorontsov@ru.mvista.com, linuxppc-dev@ozlabs.org
Subject: Re: [Patch 0/8] V4 Implement crashkernel=auto
Message-Id: <20090821170615.1ea4a4f4.akpm@linux-foundation.org>
In-Reply-To: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linuxppc-dev@ozlabs.org)

On Fri, 21 Aug 2009 02:54:12 -0400
Amerigo Wang <amwang@redhat.com> wrote:

> This series of patch implements automatically reserved memory for crashkernel,
> by introducing a new boot option "crashkernel=auto". This idea is from Neil.
> 
> In case of breaking user-space applications, it modifies this boot option after
> it decides how much memory should be reserved.
> 
> On different arch, the threshold and reserved memory size is different. Please
> refer patch 8/8 which contains an update for the documentation.
> 
> Patch 1/8 implements shrinking reserved memory at run-time, which is useful
> when more than enough memory is reserved automatically.
> 
> Note: This patchset was only tested on x86_64 with differernt memory sizes.


I'd prefer that this change had been runtime tested on ia64 and powerpc
and has had some quality review from relevant developers of those
architectures.

Looking at the cc's, I'm not sure that the powerpc guys even know about
this work?

