Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbZIINdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbZIINdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 09:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZIINdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 09:33:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:51894 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbZIINdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 09:33:21 -0400
Date: Wed, 9 Sep 2009 06:28:56 -0700
From: Greg KH <gregkh@suse.de>
To: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27.32
Message-ID: <20090909132856.GA12498@suse.de>
References: <20090909040829.GA9657@kroah.com>
 <h87kdq$us2$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h87kdq$us2$1@ger.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 09:10:50AM +0200, Arkadiusz Miskiewicz wrote:
> Greg KH wrote:
> 
> > I'm announcing the release of the 2.6.27.32 kernel.  All users of the
> > 2.6.27 kernel series are very strongly encouraged to upgrade.
> 
>   CC [M]  fs/ocfs2/aops.o
> fs/ocfs2/aops.c: In function 'ocfs2_write_cluster':
> fs/ocfs2/aops.c:1286: error: 'should_zero' undeclared (first use in this 
> function)
> fs/ocfs2/aops.c:1286: error: (Each undeclared identifier is reported only 
> once
> fs/ocfs2/aops.c:1286: error: for each function it appears in.)
> fs/ocfs2/aops.c: In function 'ocfs2_write_cluster_by_desc':
> fs/ocfs2/aops.c:1360: warning: passing argument 4 of 'ocfs2_write_cluster' 
> makes pointer from integer without a cast
> fs/ocfs2/aops.c:1235: note: expected 'struct ocfs2_alloc_context *' but 
> argument is of type 'unsigned int'
> fs/ocfs2/aops.c:1360: warning: passing argument 6 of 'ocfs2_write_cluster' 
> from incompatible pointer type
> fs/ocfs2/aops.c:1235: note: expected 'struct ocfs2_write_ctxt *' but 
> argument is of type 'struct ocfs2_alloc_context *'
> fs/ocfs2/aops.c:1360: warning: passing argument 7 of 'ocfs2_write_cluster' 
> makes integer from pointer without a cast
> fs/ocfs2/aops.c:1235: note: expected 'u32' but argument is of type 'struct 
> ocfs2_write_ctxt *'
> fs/ocfs2/aops.c:1360: error: too many arguments to function 
> 'ocfs2_write_cluster'
> make[2]: *** [fs/ocfs2/aops.o] Error 1

Yes, this was just reported :)

Do you have a proposed fix that is also upstream?

thanks,

greg k-h
