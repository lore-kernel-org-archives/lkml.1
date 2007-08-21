Return-Path: <linux-kernel-owner+w=401wt.eu-S1761701AbXHUPdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701AbXHUPdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760173AbXHUPdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:33:38 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:54366 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759870AbXHUPdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:33:38 -0400
X-Greylist: delayed 1770 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Aug 2007 11:33:37 EDT
Date: Tue, 21 Aug 2007 11:04:06 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] Fix mainline filesystems to handle ATTR_KILL_ bits
	correctly
Message-ID: <20070821150406.GA30675@cs.cmu.edu>
Mail-Followup-To: Jeff Layton <jlayton@redhat.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200708202053.l7KKrMYv017763@dantu.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708202053.l7KKrMYv017763@dantu.rdu.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 04:53:22PM -0400, Jeff Layton wrote:
> This should fix all of the filesystems in the mainline kernels to handle
> ATTR_KILL_SUID and ATTR_KILL_SGID correctly. For most of them, this is
> just a matter of making sure that they call generic_attrkill early in
> the setattr inode op.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Coda part looks fine to me. Couldn't test it beyond 'it compiles and
doesn't oops', because our userspace client unconditionally strips
setuid/setgid bits anyways.

Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>

