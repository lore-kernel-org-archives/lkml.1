Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbXJLQNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbXJLQNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760315AbXJLQGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:53 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33479 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760308AbXJLQGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:51 -0400
Subject: Re: [patch 1/2] r/o bind mounts: Dont touch the vfsmount after
	path_put()
From: Dave Hansen <haveblue@us.ibm.com>
To: Jan Blunck <jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20071012155019.985151100@hasse.suse.de>
References: <20071012155019.747515889@hasse.suse.de>
	 <20071012155019.985151100@hasse.suse.de>
Content-Type: text/plain
Date: Fri, 12 Oct 2007 09:06:26 -0700
Message-Id: <1192205187.20859.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-12 at 17:50 +0200, Jan Blunck wrote:
> plain text document attachment (vfs)
> mnt_drop_write() is called after releasing the reference to the path with
> path_put().
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>

Ugh.  Yeah.  Thanks for finding that.

Acked-by: Dave Hansen <haveblue@us.ibm.com>

-- Dave

