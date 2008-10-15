Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYJOTpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYJOTpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYJOTpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:45:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbYJOTpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:45:22 -0400
Date: Wed, 15 Oct 2008 15:45:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] vfs: replace parent == dentry->d_parent by
	IS_ROOT()
Message-ID: <20081015194519.GD24892@infradead.org>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks correct, but I'm not entirely sure it's a worthwhile cleanup,
noth version are about the same level of readability to me.

