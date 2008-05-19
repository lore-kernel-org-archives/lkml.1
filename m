Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbYESRYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbYESRYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759616AbYESRYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:24:22 -0400
Received: from mail.fieldses.org ([66.93.2.214]:52594 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYESRYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:24:21 -0400
Date: Mon, 19 May 2008 13:24:12 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "P.V.Anthony" <pvantony@singnet.com.sg>, linux-kernel@vger.kernel.org
Subject: Re: Solved - How to change the FSINFO for nfsd?
Message-ID: <20080519172412.GL7622@fieldses.org>
References: <482332CD.4010706@singnet.com.sg> <20080509042238.GC21408@fieldses.org> <20080518015733.o7n8cvhomvgos8ow@mail.mindmedia.com.sg> <alpine.LNX.1.10.0805172024440.15590@fbirervta.pbzchgretzou.qr> <1211049402.7498.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211049402.7498.4.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 02:36:42PM -0400, Trond Myklebust wrote:
> On Sat, 2008-05-17 at 20:25 +0200, Jan Engelhardt wrote:
> > On Saturday 2008-05-17 19:57, P.V.Anthony wrote:
> > > resp->f_properties = NFS3_FSF_DEFAULT;
> > >
> > > nfserr = fh_verify(rqstp, &argp->fh, 0, MAY_NOP);
> > > @@ -570,7 +570,7 @@
> > > if (sb->s_magic == 0x4d44 /* MSDOS_SUPER_MAGIC */) {
> > > resp->f_properties = NFS3_FSF_BILLYBOY;
> > > }
> > > - resp->f_maxfilesize = sb->s_maxbytes;
> > > + resp->f_maxfilesize = 0xffffffffffffffff;
> 
>    This is plain wrong! Pretending that your filesystem supports 64-bit
> files won't magically make it so.

Yes.  Could you tell us what filesystem you're using?

It's a bit bizarre that this would fix anything; I'd think the more
likely result would be errors on write and/or some kind of file
corruption.

--b.
