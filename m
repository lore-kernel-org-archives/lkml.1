Return-Path: <linux-kernel-owner+w=401wt.eu-S935202AbYEIBtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935202AbYEIBtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934866AbYEIBtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:49:15 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:62000 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935129AbYEIBtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=Ptjlkcm2KeP0p1bCkF+lpCJdX+TwKu4nUdjOMw9C8NRv9D5OzkoFnHA9PF5ujtBWduje1cnfjtJ22e2oey1wypEUWinKtxdau1ylG4XwI1o4NLIslc/iT9MDdn6UeIjhVBc/rKru3msU9sxWn6vKxtLR+P82j/sByemq+Bii9l0=
Date: Thu, 8 May 2008 20:49:05 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 8
Message-ID: <20080508204905.159a4d34@vader.jdub.homelinux.org>
In-Reply-To: <20080508142514.6990f80e.sfr@canb.auug.org.au>
References: <20080508142514.6990f80e.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008 14:25:14 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
> final fixups, it is also built with powerpc allnoconfig,
> 44x/ebony_defconfig and allyesconfig.

If you're agreeable, we should switch it from 44x/ebony_defconfig to
ppc44x_defconfig.  That will build more configurations as a result of
being a multi-board config.

josh
