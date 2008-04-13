Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYDMIKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYDMIKI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYDMIJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:09:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbYDMIJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:09:48 -0400
Date: Sun, 13 Apr 2008 04:09:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 6/7] omfs: add checksumming routines
Message-ID: <20080413080948.GG9622@infradead.org>
References: <1208041121-26787-7-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208041121-26787-7-git-send-email-me@bobcopeland.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 06:58:40PM -0400, Bob Copeland wrote:
>     OMFS checksums the metadata of all filesystem objects.  This change adds
>     the necessary functions to do so.

Looks good, but do we really need a separate source file for this one
routine?

