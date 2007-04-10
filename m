Return-Path: <linux-kernel-owner+w=401wt.eu-S966001AbXDJA2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966001AbXDJA2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932344AbXDJA2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:28:33 -0400
Received: from holomorphy.com ([66.93.40.71]:60174 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359AbXDJA2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:28:31 -0400
Date: Mon, 9 Apr 2007 17:27:50 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Zachary Amsden <zach@vmware.com>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/10] I386 pgd clone under lock fix.patch
Message-ID: <20070410002750.GZ2986@holomorphy.com>
References: <200704100006.l3A06Bao020614@zach-dev.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704100006.l3A06Bao020614@zach-dev.vmware.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 05:06:11PM -0700, Zachary Amsden wrote:
> Copying of the pgd range must happen under the pgd_lock.  This got broken by
> the paravirt changes in the -mm tree.  Badness can result if you copy the pgd
> before being added to the list when splitting or rejoining large pages.
> Signed-off-by: Zachary Amsden <zach@vmware.com>

Sorry my review missed this.

Acked-by: William Irwin <wli@holomorphy.com>


-- wli
