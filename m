Return-Path: <linux-kernel-owner+w=401wt.eu-S1761054AbXIQJN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761054AbXIQJN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbXIQJNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:13:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36550 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbXIQJNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:13:44 -0400
Date: Mon, 17 Sep 2007 10:13:40 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Nguyen Anh Quynh <aquynh@gmail.com>
Subject: Re: [PATCH 001/104] KVM: Fix *nopage() in kvm_main.c
Message-ID: <20070917091340.GB2083@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, Nguyen Anh Quynh <aquynh@gmail.com>
References: <11900179463203-git-send-email-avi@qumranet.com> <11900179461472-git-send-email-avi@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11900179461472-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 10:30:43AM +0200, Avi Kivity wrote:
> From: Nguyen Anh Quynh <aquynh@gmail.com>
> 
> *nopage() in kvm_main.c should only store the type of mmap() fault if
> the pointers are not NULL. This patch fixes the problem.

Care to convert it to ->faul while you're at it?
