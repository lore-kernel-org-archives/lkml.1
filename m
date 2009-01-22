Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbZAVVHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbZAVVHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbZAVVG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:06:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbZAVVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:06:57 -0500
Date: Thu, 22 Jan 2009 16:06:55 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: smfrench@gmail.com, linux-fsdevel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] [PATCH] cifs: wrap cifs_dnotify_thread in
	CONFIG_BROKEN
Message-ID: <20090122210655.GA6065@infradead.org>
References: <1232642078-9717-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232642078-9717-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 11:34:38AM -0500, Jeff Layton wrote:
> This thread never actually did anything useful, so comment it out by
> #ifdef'ing it in CONFIG_BROKEN. My preference would be to remove it
> altogether, but it's not my call.

Please just kill it.  It's not only useless but also ugly, so keeping it
around it a double disservice to the mother nature.

