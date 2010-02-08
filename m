Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab0BHDqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 22:46:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:46555 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab0BHDqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 22:46:43 -0500
Subject: Re: [PATCH 01/10] arch/powerpc: Fix continuation line formats
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <1265049037.25140.301.camel@Joe-Laptop.home>
References: <cover.1264967493.git.joe@perches.com>
	 <d8e2cb6523906c5e77bb13ea9ffc077a9310dc9e.1264967498.git.joe@perches.com>
	 <1264990574.8287.15.camel@pasglop>
	 <1265049037.25140.301.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 14:46:26 +1100
Message-ID: <1265600786.8287.229.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 10:30 -0800, Joe Perches wrote:
> On Mon, 2010-02-01 at 13:16 +1100, Benjamin Herrenschmidt wrote:
> > On Sun, 2010-01-31 at 12:02 -0800, Joe Perches wrote:
> > > String constants that are continued on subsequent lines with \
> > > are not good.
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > You want me to take that in the powerpc tree ?
> 
> Yes please.
> 
> > A minor glitch below tho...
> > > @@ -349,7 +349,7 @@ static int __init nvram_create_os_partition(void)
> > >  	rc = ppc_md.nvram_write((char *)&seq_init, sizeof(seq_init), &tmp_index);
> > >  	if (rc <= 0) {
> > >  		printk(KERN_ERR "nvram_create_os_partition: nvram_write "
> > > -				"failed (%d)\n", rc);
> > > +		       "failed (%d)\n", rc);
> > >  		return rc;
> > >  	}
> > 
> > The above is objectionable :-)
> 
> Can you drop that section or do you need another patch?

I'll sort it out. Thanks.

Cheers,
Ben.


