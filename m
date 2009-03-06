Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZCFTol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZCFTol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZCFTo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:44:29 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42596 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbZCFTo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:44:28 -0500
Date: Fri, 6 Mar 2009 12:44:11 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 0/7] PCI: Linux kernel SR-IOV support
Message-ID: <20090306194411.GC25995@parisc-linux.org>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235112888-9524-1-git-send-email-yu.zhao@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 02:54:41PM +0800, Yu Zhao wrote:
> Following patches are intended to support SR-IOV capability in the
> Linux kernel. With these patches, people can turn a PCI device with
> the capability into multiple ones from software perspective, which
> will benefit KVM and achieve other purposes such as QoS, security,
> and etc.

I reviewed this round of patches on the plane ... I'll respond to each
patch individually, but in general this all looks much better than the
first round I reviewed.

> Physical Function driver patches for Intel 82576 NIC are available:
>   http://patchwork.kernel.org/patch/8063/
>   http://patchwork.kernel.org/patch/8064/
>   http://patchwork.kernel.org/patch/8065/
>   http://patchwork.kernel.org/patch/8066/

I need to review this driver; I haven't done that yet.  Has anyone else?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
