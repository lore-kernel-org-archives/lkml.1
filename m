Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYGXUTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYGXUTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYGXUT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:19:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:10207 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYGXUTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=JNzz4pb8keZr8InyTr4CxNPbxBTu/7rtqZbNgG2KUupEsWwVP0/7wBEEL4+z/46Npz
         wUI3puvcUv71jyN/5oy4JH1TNAFTUYMIxA75DEhmLqYeApHtM/7hhu6LSLN67BFyZ+rj
         7EAI720DqssCdvnRHgYymexL97b3qQASxxEbw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] remove <linux/hdreg.h>
Date: Thu, 24 Jul 2008 22:11:52 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807242137.58606.bzolnier@gmail.com> <20080724194915.GA23998@infradead.org>
In-Reply-To: <20080724194915.GA23998@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242211.53655.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008, Christoph Hellwig wrote:
> On Thu, Jul 24, 2008 at 09:37:58PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > It has no in-kernel users now and can be removed.
> 
> But beeing an exported header it has userspace users.  Plese keep it
> and just leave the ioctl defintions as need by userspace in it instead
> of renaming that part to hdio_ioctls.h.

Agreed w.r.t. to keeping it (the last patch was more of rfc than intended
to be commited, sorry that I didn't mark it as such) but what's wrong with
moving ioctl definitions to hdio_ioctls.h so we have clean separation of
obsoleted userspace-only stuff & userspace/kernel stuff?

[ The hdio_ioctls.h include is also exported to userspace and included
  by hdreg.h internally (patch #1) so userspace should be unaffected. ]

Thanks,
Bart
