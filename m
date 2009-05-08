Return-Path: <linux-kernel-owner+w=401wt.eu-S1764708AbZEHAm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764708AbZEHAm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763873AbZEHAWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:22:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:58137 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763785AbZEHAWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:22:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,313,1239001200"; 
   d="scan'208";a="410508822"
Date: Thu, 7 May 2009 17:22:40 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org,
       Sheng Yang <sheng@linux.intel.com>, Matthew Wilcox <matthew@wil.cx>,
       kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Message-ID: <20090508002240.GA30192@linux.intel.com>
References: <20090507082841.GA31751@redhat.com> <20090507095302.GI8112@parisc-linux.org> <200905071819.54426.sheng@linux.intel.com> <200905080925.01398.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905080925.01398.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 09:25:00AM +0930, Rusty Russell wrote:
> Sheng is absolutely right, that's a horrid API.

But the API already exists, and is in use by 27 drivers.  If this were a
change to the API, I'd be against it, but it is the existing API.

