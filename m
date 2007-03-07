Return-Path: <linux-kernel-owner+w=401wt.eu-S1422676AbXCGJjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422676AbXCGJjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422682AbXCGJjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:39:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35054 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422676AbXCGJi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:38:58 -0500
Date: Wed, 7 Mar 2007 09:38:57 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 5/6] UDF cleanup and fixes
Message-ID: <20070307093857.GF14863@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	akpm@osdl.org
References: <20070306164447.GC3661@duck.suse.cz> <20070306164805.GH3661@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306164805.GH3661@duck.suse.cz>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 05:48:05PM +0100, Jan Kara wrote:
> Make UDF work correctly for files larger than 1GB. As no extent can
> be longer than (1<<30)-blocksize bytes, we have to create several extents
> if a big hole is being created. As a side-effect, we now don't discard
> preallocated blocks when creating a hole.

Ok.

