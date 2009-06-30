Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZF3Rol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZF3Rol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZF3RoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:44:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39567 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZF3RoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:44:16 -0400
Date: Tue, 30 Jun 2009 13:44:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 0/10] Fix page_mkwrite() for blocksize < pagesize
	(version 3)
Message-ID: <20090630174419.GA15102@infradead.org>
References: <1245088797-29533-1-git-send-email-jack@suse.cz> <20090616143424.GA22002@infradead.org> <20090616144217.GA18063@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616144217.GA18063@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 04:42:17PM +0200, Jan Kara wrote:
>   Good point, I should have mentioned in the changelog: fsx-linux is able
> to trigger the problem quite quickly.
>   I have also written a simple program for initial testing of the fix
> (works only for 1K blocksize and 4K pagesize) - it's attached.

I haven't been able to trigger anything with it on either xfs or ext4.

