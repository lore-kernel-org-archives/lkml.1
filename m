Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbXIOCcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbXIOCcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 22:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbXIOCci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 22:32:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001AbXIOCch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 22:32:37 -0400
Date: Fri, 14 Sep 2007 19:32:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH 2/2] Fix user namespace exiting OOPs
Message-Id: <20070914193233.77138604.akpm@linux-foundation.org>
In-Reply-To: <20070914182355.GA9810@sergelap.austin.ibm.com>
References: <46EA88BA.5020005@openvz.org>
	<20070914182355.GA9810@sergelap.austin.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 13:23:55 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> > run on kernel with CONFIG_USER_NS turned on will oops the
> > kernel immediately.
> > 
> > This was spotted during OpenVZ kernel testing.
> > 
> > Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> > Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
> 
> Good spot.  Interesting solution :)
> 

Do we want to fix this in 2.6.23?

If so then at present I'll need to merge 

kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
convert-uid-hash-to-hlist.patch
fix-user-namespace-exiting-oops.patch

which is rather a lot of merging at this stage - surely more than
is really needed?
