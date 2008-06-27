Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbYF0OTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbYF0OTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYF0OTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:19:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbYF0OTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:19:40 -0400
Date: Fri, 27 Jun 2008 10:19:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation
	automatically
Message-ID: <20080627141910.GD5801@redhat.com>
References: <1214510048-21215-1-git-send-email-bwalle@suse.de> <20080627133256.GB5801@redhat.com> <20080627134212.GC5801@redhat.com> <20080627160656.06f71661@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627160656.06f71661@halley.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 04:06:56PM +0200, Bernhard Walle wrote:
> * Vivek Goyal [2008-06-27 09:42]:
> > 
> > Thinking more about. Let me step back. I think it is not good idea to
> > take this kernel take decision about the capability of kernel being
> > loaded. There is no way we can find out now that if a kernel is capable
> > of running from this memory location or not. This is highly variable. So,
> > please ignore above comment.
> 
> Maybe below 4G makes sense. Because you need some 32 bit memory for DMA.
> That's mostly an architecture limitation, so that could make sense to
> check here.
> 

Even if you need some 32bit memory in the lower regions, kexec can handle
it with backup segment mechanism (currently 640K). We can always increse
the backup region size.

So I would think that it is best to leave it without any checking and 
then let kexec-tools handle it.

Thanks
Vivek
