Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZIOXVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZIOXVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbZIOXVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:21:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbZIOXVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:21:01 -0400
Date: Tue, 15 Sep 2009 19:21:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 20/20] Driver Core: devtmpfs - kernel-maintained
	tmpfs-based /dev
Message-ID: <20090915232104.GC7636@infradead.org>
References: <20090915181247.GA32167@kroah.com> <1253041976-1111-20-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253041976-1111-20-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NACK, this touches init code to mount stuff inside the namespace fro ma
filesystem driver which is a big no-go.  I also can't see any ACK or
similar from VFS people for that crap (obviously)

