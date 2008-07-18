Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbYGRTMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbYGRTMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 15:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYGRTMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 15:12:31 -0400
Received: from mail.fieldses.org ([66.93.2.214]:38261 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbYGRTMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 15:12:31 -0400
Date: Fri, 18 Jul 2008 15:12:28 -0400
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] nfs: nfs4xdr use C99 array initializers
Message-ID: <20080718191228.GD12007@fieldses.org>
References: <1216355583.6029.137.camel@brick> <20080718180115.GJ8035@fieldses.org> <1216404127.6029.149.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216404127.6029.149.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 11:02:07AM -0700, Harvey Harrison wrote:
> On Fri, 2008-07-18 at 14:01 -0400, J. Bruce Fields wrote:
> > On Thu, Jul 17, 2008 at 09:33:03PM -0700, Harvey Harrison wrote:
> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > OK, thanks.  But I'd rather just skip the macro:
> > 
> > > +#define NFSD4_DEC_OP(idx, op)	[(idx)] = (nfsd4_dec)(op)
> > > -	[OP_ACCESS]		(nfsd4_dec)nfsd4_decode_access,
> > > -	[OP_CLOSE]		(nfsd4_dec)nfsd4_decode_close,
> > > -	[OP_COMMIT]		(nfsd4_dec)nfsd4_decode_commit,
> > > -	[OP_CREATE]		(nfsd4_dec)nfsd4_decode_create,
> > > -	[OP_DELEGPURGE]		(nfsd4_dec)nfsd4_decode_notsupp,
> > ...
> > > +	NFSD4_DEC_OP(OP_ACCESS, nfsd4_decode_access),
> > > +	NFSD4_DEC_OP(OP_CLOSE, nfsd4_decode_close),
> > > +	NFSD4_DEC_OP(OP_COMMIT, nfsd4_decode_commit),
> > > +	NFSD4_DEC_OP(OP_CREATE, nfsd4_decode_create),
> > > +	NFSD4_DEC_OP(OP_DELEGPURGE, nfsd4_decode_notsupp),
> > 
> > and just add equals signs, if there's no substantial objection.
> > 
> 
> None here.

Thanks, done.--b.
