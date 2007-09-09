Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbXIIOTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbXIIOTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 10:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbXIIOSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 10:18:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38672 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbXIIOSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 10:18:53 -0400
Date: Sun, 9 Sep 2007 15:18:49 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net,
       ecryptfs-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
       unionfs@filesystems.org
Subject: Re: [PATCH 0/7] fix setuid/setgid clearing in networked filesystems (take 5)
Message-ID: <20070909141849.GA422@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cifs-client@lists.samba.org,
	nfs@lists.sourceforge.net, ecryptfs-devel@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org, unionfs@filesystems.org
References: <200709041436.l84EahTs009995@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709041436.l84EahTs009995@dantu.rdu.redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good content-wise.  But please move the patches that make sure
we never trip the BUG before the patch introducing them so that we
get a cleanly bisectable tree.
