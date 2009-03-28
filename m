Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbZC1Vke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbZC1Vke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbZC1VkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:40:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57219 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZC1VkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:40:21 -0400
Date: Sat, 28 Mar 2009 18:40:08 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Support for GB pages in KVM
Message-ID: <20090328214008.GB4694@amt.cnet>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 03:31:52PM +0100, Joerg Roedel wrote:
> Hi,
> 
> this patchset extends the KVM MMU implementation to support 1GB pages as
> supported by AMD family 16 processors. These patches enable support for
> 1 GB pages with Nested Paging. Support for these pages in the shadow
> paging code was also developed but does not run stable yet. The patch
> for shadow-paging support is not included in this series and will be
> sent out seperatly.

Looks generally sane. I'm not sure its even worthwhile to support
GBpages with softmmu, because the chance of finding an area without
shadowed (write protected) pages is much smaller than with 2MB pages.

Have any numbers to share?

