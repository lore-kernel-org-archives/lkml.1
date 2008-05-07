Return-Path: <linux-kernel-owner+w=401wt.eu-S933065AbYEGTug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbYEGTug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYEGTuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:50:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:59756 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYEGTuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:50:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oOn3bEYK6PqHT10glZQNVCeEHAAqYkvV/GJhkis5eGw0pbpKcGmWEushvvi+B6ehxgJuN1psrAnJtRiZuQlMYR2rciWD/wRAHUkglmwqd1cdmQGnb8uIfRgg5ns2ua7amT1jLf2BgVIY/rh3aEnF6UyA4hJCkrjBNupcFSvHnM0=
Date: Thu, 8 May 2008 00:45:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 4/6] seq_file: add function to write binary data
Message-ID: <20080507204533.GA8850@martell.zuzino.mipt.ru>
References: <481F26B5.7010708@de.ibm.com> <20080505213644.b153ee68.akpm@linux-foundation.org> <20080507201757.GC5131@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507201757.GC5131@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 12:17:57AM +0400, Alexey Dobriyan wrote:
> > > +		memcpy(m->buf + m->count, s, len);
> > > +		m->count += len;
> > > +		return 0;
> > > +	}
> > > +	m->count = m->size;
> > > +	return -1;
> > > +}
> > > +EXPORT_SYMBOL(seq_write);
> 
> I'd call function seq_memcpy() though.

Or even seq_blob().

