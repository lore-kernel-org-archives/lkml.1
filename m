Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbXIZIbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbXIZIbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXIZIb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:31:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53592 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXIZIb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:31:26 -0400
Date: Wed, 26 Sep 2007 09:31:21 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 05/25] Unionfs: cast page->index loff_t before shifting
Message-ID: <20070926083121.GA8421@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	viro@ftp.linux.org.uk
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu> <1190776207595-git-send-email-ezk@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190776207595-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 11:09:44PM -0400, Erez Zadok wrote:
> Fixes bugs in number promotion/demotion computation, as per
> <http://lkml.org/lkml/2007/9/20/17>

It's better to use te page_offset helper as that avoids any confusion
on where to cast.

