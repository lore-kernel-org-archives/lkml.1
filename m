Return-Path: <linux-kernel-owner+w=401wt.eu-S1764621AbXH1Tf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764621AbXH1Tf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764243AbXH1TdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:33:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46210 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764290AbXH1TdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:33:13 -0400
Date: Tue, 28 Aug 2007 20:33:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, lguest@ozlabs.org,
       v9fs-developer@lists.sourceforge.net, kvm-devel@lists.sourceforge.net,
       Latchesar Ionkov <lucho@ionkov.net>
Subject: Re: [RFC] 9p: add KVM/QEMU pci transport
Message-ID: <20070828193303.GA6013@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	linux-kernel@vger.kernel.org, lguest@ozlabs.org,
	v9fs-developer@lists.sourceforge.net,
	kvm-devel@lists.sourceforge.net,
	Latchesar Ionkov <lucho@ionkov.net>
References: <11883271601857-git-send-email-ericvh@gmail.com> <11883271601227-git-send-email-ericvh@gmail.com> <11883271602233-git-send-email-ericvh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11883271602233-git-send-email-ericvh@gmail.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 01:52:38PM -0500, Eric Van Hensbergen wrote:
> +config NET_9P_PCI
> +	depends on NET_9P
> +	tristate "9p PCI Shared Memory Transport (Experimental)"

shouldn't this depend on CONFIG_PCI?

