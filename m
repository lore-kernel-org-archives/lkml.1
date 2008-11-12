Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYKLSyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYKLSyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYKLSxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:53:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:13858 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYKLSxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:53:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tx2jOGoWJ2Xp68MMirRz8f7feozYr9vQMp7+NYygxvVUNQ+zC/DE0+nEHjFdTzpQBv
         f1EdEN7qBjmzJ9cjJJsx0KIeFq/UDCnR8QijBvcNIS16ZfKNh7NkKeSeopLkEkBY8rYw
         TCzL//lSWmUs9JpZBnmYgp0i1Bu+lE4FiX3UY=
Subject: Re: [RFC-PATCH] ieee1394: endian annotations of drivers/ieee1394
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <491B2309.1090900@s5r6.in-berlin.de>
References: <1226514321.16649.7.camel@brick>
	 <491B2309.1090900@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 10:53:46 -0800
Message-Id: <1226516026.16649.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-12 at 19:40 +0100, Stefan Richter wrote:
> Harvey Harrison wrote:
> > Annotations are mostly trivial, quadlet_t -> __be32, octlet_t -> __be64
> > which will have no effect on compiled code.
> 
> 
> I haven't looked at it yet but have point out one important thing:
> This is one of the many issues in drivers/ieee1394 which have already
> been fixed by introducing drivers/firewire.  I appreciate the work which
> you put into this, but I don't know yet if we want to take it in.

No worries, I've just been working on getting things down to a level where
__CHECK_ENDIAN__ could be enabled by default and this was one of the
remaining 'noisier' areas in an allyesconfig.  In the end the patches
didn't end up being too intrusive other than the csr.c and sbp.c bits.

Cheers,

Harvey


