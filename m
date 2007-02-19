Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbXBSLJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbXBSLJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbXBSLJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:09:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42339 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbXBSLJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:09:31 -0500
Date: Mon, 19 Feb 2007 11:09:30 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 22/44 take 2] [UBI] background thread unit implementation
Message-ID: <20070219110930.GF16930@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165615.5845.79171.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217165615.5845.79171.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This really should use the linux/kthread.h infrastructure, and most of the
code in here would simply go away.
