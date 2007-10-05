Return-Path: <linux-kernel-owner+w=401wt.eu-S1763171AbXJEOrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763171AbXJEOrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 10:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759883AbXJEOrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 10:47:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40862 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059AbXJEOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 10:47:08 -0400
Date: Fri, 5 Oct 2007 15:47:04 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/32] IGET: Introduce a function to register iget failure [try #2]
Message-ID: <20071005144704.GB3072@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
	torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk> <20071004155617.2814.46853.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004155617.2814.46853.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 04:56:17PM +0100, David Howells wrote:
> Introduce a function to register failure in an inode construction path.  This
> includes marking the inode under construction as bad, unlocking it and
> releasing it.

I'm a bit unconfortable with the name, but except for that this function
and the users added in the next patches look fine.

