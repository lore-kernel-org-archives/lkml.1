Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbXLWMJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbXLWMJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 07:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXLWMIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 07:08:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57485 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbXLWMIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 07:08:49 -0500
Date: Sun, 23 Dec 2007 12:08:48 +0000
From: Christoph Hellwig <hch@infradead.org>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/24] udf: convert UDF_SB_VOLIDENT macro to
	udf_sb_volume_ident function
Message-ID: <20071223120848.GC18629@infradead.org>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com> <1198374674-12128-5-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198374674-12128-5-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 02:50:54AM +0100, marcin.slusarz@gmail.com wrote:
> - change UDF_SB_VOLIDENT macro to udf_sb_volume_ident inline function
> - rename s_volident field to s_volume_ident

Please just use the field directly without an accessor.  And as usual
there's a lot of opportunity to have a nice local variable for the udf
superblock.

