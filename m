Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYDMIJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYDMIJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYDMIIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:08:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYDMIIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:08:48 -0400
Date: Sun, 13 Apr 2008 04:08:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/7] omfs: add file routines
Message-ID: <20080413080847.GE9622@infradead.org>
References: <1208041121-26787-5-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208041121-26787-5-git-send-email-me@bobcopeland.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 06:58:38PM -0400, Bob Copeland wrote:
>     Add functions for reading and manipulating the storage of file data in
>     the extent-based OMFS.

Looks good.  You might want to investigate using the mpage_ routines for
readpage/readpages to make reading files less overhead.

