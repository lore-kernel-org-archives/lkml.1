Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZIVLbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZIVLbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbZIVLbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:31:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbZIVLbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:31:42 -0400
Subject: Re: startx broken on today's git tree
From: Peter Zijlstra <peterz@infradead.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       airlied@linux.ie
In-Reply-To: <7b6bb4a50909220412v1b4f626bq2a356d3b1e0d1009@mail.gmail.com>
References: <7b6bb4a50909220412v1b4f626bq2a356d3b1e0d1009@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Sep 2009 13:31:35 +0200
Message-Id: <1253619095.7695.45.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 19:12 +0800, Xiaotian Feng wrote:
> Hi,
> 
>     I used today's git tree with FC11 configs plus some debug configs,
> then I found my FC11 can not startx anymore...  Each time I run
> startx, I'll get a Fatal error:
> 
>     (EE) Screen(s) found, but none have a usable configuration.
> 
>     Then from dmesg, I saw flood messages:
> 
>  [drm:radeon_cp_getparam_kms] *ERROR* invalid ioctl with kms
> radeon_cp_getparam_kms
> 
>     Attach is my dmesg log, any ideas on this issue? Thank you.

Disable radeon KMS, or upgrade your xorg radeon driver.

I don't think F11 includes a new enough radeon driver for KMS to work.
