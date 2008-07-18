Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbYGRSCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbYGRSCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYGRSCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:02:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:47711 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYGRSCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WPJVu9vZfx/SVMAncS0IHETmEIfHaFLvUaVlG3/Ee9xzng/ThPLmDSerjbwt0dclec
         2N/o9vIM4RgN0/KHZFhw0vtiTaUeQCmvHmqf+zQTpoekwvYzbhKf4pxVmpAaEmDJvS0T
         n4eHAMKfY5Mwk62uOhzX9wv/BTWp8rzNfjWjg=
Subject: Re: [PATCH 1/2] nfs: nfs4xdr use C99 array initializers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080718180115.GJ8035@fieldses.org>
References: <1216355583.6029.137.camel@brick>
	 <20080718180115.GJ8035@fieldses.org>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 11:02:07 -0700
Message-Id: <1216404127.6029.149.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 14:01 -0400, J. Bruce Fields wrote:
> On Thu, Jul 17, 2008 at 09:33:03PM -0700, Harvey Harrison wrote:
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> OK, thanks.  But I'd rather just skip the macro:
> 
> > +#define NFSD4_DEC_OP(idx, op)	[(idx)] = (nfsd4_dec)(op)
> > -	[OP_ACCESS]		(nfsd4_dec)nfsd4_decode_access,
> > -	[OP_CLOSE]		(nfsd4_dec)nfsd4_decode_close,
> > -	[OP_COMMIT]		(nfsd4_dec)nfsd4_decode_commit,
> > -	[OP_CREATE]		(nfsd4_dec)nfsd4_decode_create,
> > -	[OP_DELEGPURGE]		(nfsd4_dec)nfsd4_decode_notsupp,
> ...
> > +	NFSD4_DEC_OP(OP_ACCESS, nfsd4_decode_access),
> > +	NFSD4_DEC_OP(OP_CLOSE, nfsd4_decode_close),
> > +	NFSD4_DEC_OP(OP_COMMIT, nfsd4_decode_commit),
> > +	NFSD4_DEC_OP(OP_CREATE, nfsd4_decode_create),
> > +	NFSD4_DEC_OP(OP_DELEGPURGE, nfsd4_decode_notsupp),
> 
> and just add equals signs, if there's no substantial objection.
> 

None here.

Harvey

