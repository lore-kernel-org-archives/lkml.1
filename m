Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbZIQFoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbZIQFoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 01:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZIQFoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 01:44:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbZIQFoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 01:44:02 -0400
Date: Wed, 16 Sep 2009 22:43:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, hpa@zytor.com, aarcange@redhat.com
Subject: Re: [PATCHv2 1/2] mm: export use_mm/unuse_mm to modules
Message-Id: <20090916224345.3b5212b4.akpm@linux-foundation.org>
In-Reply-To: <20090917053817.GB6770@redhat.com>
References: <cover.1249992497.git.mst@redhat.com>
	<20090811212752.GB26309@redhat.com>
	<20090811151010.c9c56955.akpm@linux-foundation.org>
	<20090917053817.GB6770@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 08:38:18 +0300 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> Hi Andrew,
> On Tue, Aug 11, 2009 at 03:10:10PM -0700, Andrew Morton wrote:
> > On Wed, 12 Aug 2009 00:27:52 +0300
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > vhost net module wants to do copy to/from user from a kernel thread,
> > > which needs use_mm (like what fs/aio has).  Move that into mm/ and
> > > export to modules.
> > 
> > OK by me.  Please include this change in the virtio patchset.  Which I
> > shall cheerfully not be looking at :)
> 
> The virtio patches are somewhat delayed as we are ironing out the
> kernel/user interface with Rusty. Can the patch moving use_mm to mm/ be
> applied without exporting to modules for now? This will make it easier
> for virtio which will only have to patch in the EXPORT line.

That was 10,000 patches ago.

> I also have a small patch optimizing atomic usage in use_mm (which I did for
> virtio) and it's easier to apply it if the code is in the new place.
> 
> If ok, pls let me know and I'll post the patch without the EXPORT line.

Please just send them all out.
