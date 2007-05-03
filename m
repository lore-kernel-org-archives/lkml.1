Return-Path: <linux-kernel-owner+w=401wt.eu-S1162153AbXECQAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162153AbXECQAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162156AbXECQAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:00:53 -0400
Received: from gw.goop.org ([64.81.55.164]:48132 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162153AbXECQAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:00:51 -0400
Message-ID: <463A0730.8070007@goop.org>
Date: Thu, 03 May 2007 09:00:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
Subject: Re: netfront for review
References: <4637D672.5030706@goop.org> <1178077033.28659.173.camel@localhost.localdomain> <4638EAC0.7020107@goop.org> <46399057.4000409@redhat.com> <20070503151756.GA29629@infradead.org> <463A01F7.90500@redhat.com>
In-Reply-To: <463A01F7.90500@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> Drawback is that the guest kernel wouldn't work with older xen
> versions (dom0 netback driver to be exact) any more.  Probably
> wouldn't be a showstopper though, given that xen 3.0.3 probably is
> almost one year out by the time 2.6.22 will be released ...

I don't think we've decided how backwards-compatible the pv_ops guest
should be.  I've been working on the basis "as much as possible", so
long as it isn't a large burden.

    J
