Return-Path: <linux-kernel-owner+w=401wt.eu-S1760352AbZBMDpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352AbZBMDpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 22:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbZBMDpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 22:45:15 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:57463 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbZBMDpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 22:45:14 -0500
Date: Thu, 12 Feb 2009 20:44:57 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, dwmw2@infradead.org, linux-pci@vger.kernel.org,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] ATS capability support for Intel IOMMU
Message-ID: <20090213034457.GM3624@parisc-linux.org>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 08:50:32PM +0800, Yu Zhao wrote:
>   2, avoid using pci_find_ext_capability every time when reading ATS
>      Invalidate Queue Depth (Matthew Wilcox)

er ... I didn't say it was a problem.  I said I couldn't tell if it was a
problem.  There's no point in taking up an extra 4 bytes per pci_dev if
it's not a performance problem.  How often do we query the queue depth?
Is this something a device driver will call once per device and then
remember for itself, or only use at setup?  Or is it something we call
every millisecond?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
