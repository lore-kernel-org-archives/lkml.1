Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab0CBOcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:32:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab0CBOcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:32:22 -0500
Date: Tue, 2 Mar 2010 11:26:04 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7 v3] Rework of msrpm optimization and additional fixes
 for nested svm
Message-ID: <20100302142604.GA21780@amt.cnet>
References: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267454080-2513-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 03:34:33PM +0100, Joerg Roedel wrote:
> Hi,
> 
> this is the third round of the msrpm merge optimization patches for
> nested svm.  The change to the previous post it the introduction of an
> direc_access_msrs list which contains all msrs that a guest might
> directly access. This list is used to initialize the msrpm bitmaps and
> the msrpm_offset table used for merging two tables. This optimization
> more than doubles the performance of kernel compiles in the nested guest
> using nested-shadow paging.
> The other random fixes in this set were not changed to the last version
> of this set. Patch 1/7 is new because it was forgotten in the last post.
> 
> Thanks,
> 
> 	Joerg

Applied, thanks.

