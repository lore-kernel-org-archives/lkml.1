Return-Path: <linux-kernel-owner+w=401wt.eu-S1764308AbXE2JNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764308AbXE2JNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 05:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbXE2JNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 05:13:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34342 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXE2JNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 05:13:42 -0400
Date: Tue, 29 May 2007 10:13:40 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH 1/2] [AGPGART] intel_agp: cleanup intel private data
Message-ID: <20070529091340.GA27950@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
References: <20070529062005.GA5097@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529062005.GA5097@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 02:20:05PM +0800, Wang Zhenyu wrote:
> +static struct _intel_private {
> +	struct pci_dev *pcidev;	/* device one */
>  	volatile u8 __iomem *registers;
> +	volatile u32 __iomem *gtt;		/* I915G */

Neither of these should be volatile.

