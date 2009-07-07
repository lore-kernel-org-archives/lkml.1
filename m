Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbZGGOxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbZGGOxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZGGOxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:53:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47423 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbZGGOxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:53:14 -0400
Date: Tue, 7 Jul 2009 10:53:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 2/4] fs: use new truncate helpers
Message-ID: <20090707145313.GB3762@infradead.org>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144600.GD2714@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707144600.GD2714@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 04:46:00PM +0200, Nick Piggin wrote:
> 
> Update some fs code to make use of new helper functions introduced
> in the previous patch. Should be no significant change in behaviour
> (except CIFS now calls send_sig under i_lock, via inode_newsize_ok).

Looks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>
