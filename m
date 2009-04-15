Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbZDOMgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbZDOMgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759223AbZDOMgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:36:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58812 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758920AbZDOMgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:36:23 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: add self-tests for rfc4309(ccm(aes))
Date: Wed, 15 Apr 2009 08:35:38 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.29.1-54.fc11.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
References: <200904091434.59639.jarod@redhat.com> <200904131911.01596.jarod@redhat.com> <20090415112053.GA10188@gondor.apana.org.au>
In-Reply-To: <20090415112053.GA10188@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904150835.38818.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 April 2009 07:20:53 Herbert Xu wrote:
> On Mon, Apr 13, 2009 at 07:11:00PM -0400, Jarod Wilson wrote:
> >
> > +			case -EBADMSG:
> > +				if (template[i].novrfy)
> > +					/* verification failure was expected */
> > +					goto next_aead_vector;
> >  				/* fall through */
> 
> We should also fail if novrfy is true and we get a 0 return value.

Oh, yeah, whoops, missed that case. Will add that.

> I'd also prefer to have the novrfy infrastructure changes to go
> into a separate patch.

Yeah, wasn't sure if I should do infra separate or not. I'll split
things up a bit for the next submission that includes the catch for
novrfy true, ret 0.

-- 
Jarod Wilson
jarod@redhat.com
