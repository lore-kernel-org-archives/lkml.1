Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZJNViM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZJNViM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbZJNViM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:38:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbZJNViL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:38:11 -0400
Date: Wed, 14 Oct 2009 17:37:42 -0400
From: Dave Jones <davej@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [X86] PCI: Use generic cacheline sizing instead of per-vendor
	tests.
Message-ID: <20091014213742.GA17311@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20091014203139.GA2336@redhat.com> <20091014143054.76874f30@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014143054.76874f30@jbarnes-g45>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 02:30:54PM -0700, Jesse Barnes wrote:
 > On Wed, 14 Oct 2009 16:31:39 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > Instead of the PCI code needing to have code to determine the 
 > > cacheline size of each processor, use the data the cpu identification
 > > code should have already determined during early boot.
 > > 
 > > (The vendor checks are also incomplete, and don't take into account
 > >  modern CPUs)
 > > 
 > > I've been carrying a variant of this code in Fedora for a while,
 > > that prints debug information.  There are a number of cases where we
 > > are currently setting the PCI cacheline size to 32 bytes, when the CPU
 > > cacheline size is 64 bytes.  With this patch, we set them both the
 > > same.
 > > 
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 > > 
 > 
 > Does this improve performance enough to warrant putting it into the
 > current cycle?  Or is queuing it for 2.6.33 sufficient?

I haven't done any performance testing with/without. My intentions
were purely from a correctness standpoint. 

It's not critical, and we've lived with this bug for a long time,
so waiting is fine.

	Dave

