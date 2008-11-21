Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbYKUCbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbYKUCbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 21:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYKUCbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 21:31:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:30659 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYKUCbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 21:31:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WUfIW0AvJR2RKDvVHm0kDA9W7iKIsOesdK5PqQtdC8Y3lheRWrthqp6BMexGcB70u/
         omgAFvoQRVnXDjMH0sPkFrYDf7c7CDbmBJ96v1xv2I+txeasz+HIY7bj/+aDzvm5I4+T
         E+EMIxSeqyq6TVq34jp5f0TpW4C3wAqb6o/Pw=
Date: Fri, 21 Nov 2008 05:34:55 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/45] FS-Cache: Add use of /proc and presentation of
	statistics [ver #41]
Message-ID: <20081121023454.GA4655@x200.localdomain>
References: <20081121001539.GA5889@x200.localdomain> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144236.10667.83390.stgit@warthog.procyon.org.uk> <16493.1227233841@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16493.1227233841@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 02:17:21AM +0000, David Howells wrote:
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > This is overly complex for unclear need. Just set_printf() all these lines
> > and drop iterator business. Use single_open()! Ditto for histo stuff.
> 
> There is no set_printf() in Linus's tree.  Did you mean seq_printf(), or is

Yes, seq_printf() of course.
