Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbXHTVHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbXHTVHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbXHTVHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:07:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38868 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbXHTVHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:07:07 -0400
Subject: Re: [Jfs-discussion] [PATCH 2/4] Fix mainline filesystems to
	handle ATTR_KILL_ bits correctly
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net
In-Reply-To: <200708202053.l7KKrMYv017763@dantu.rdu.redhat.com>
References: <200708202053.l7KKrMYv017763@dantu.rdu.redhat.com>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 16:07:05 -0500
Message-Id: <1187644025.6471.11.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 16:53 -0400, Jeff Layton wrote:
> This should fix all of the filesystems in the mainline kernels to handle
> ATTR_KILL_SUID and ATTR_KILL_SGID correctly. For most of them, this is
> just a matter of making sure that they call generic_attrkill early in
> the setattr inode op.

Here's my ack for the jfs piece.

> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

-- 
David Kleikamp
IBM Linux Technology Center

