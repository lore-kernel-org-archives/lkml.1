Return-Path: <linux-kernel-owner+w=401wt.eu-S1761787AbXEOGVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761787AbXEOGVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 02:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759441AbXEOGVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 02:21:16 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49162 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333AbXEOGVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 02:21:15 -0400
Date: Tue, 15 May 2007 11:58:37 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  5/14] Introduce union stack
Message-ID: <20070515062837.GB3465@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com> <20070514094047.GG4139@in.ibm.com> <1179182457.2836.92.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179182457.2836.92.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 03:40:57PM -0700, Badari Pulavarty wrote:
> On Mon, 2007-05-14 at 15:10 +0530, Bharata B Rao wrote:
< snip >
> > +
> > +/* Shouldn't be called with last reference to union_info */
> > +static inline void union_put_and_unlock(struct union_info *uinfo)
> > +{
> > +	union_put(uinfo);
> > +	__union_unlock(&uinfo->u_mutex);
> 	               ^^^^^^^^^^^^^^^^^^^
> 
> It should be
> 	
> 	__union_unlock(uinfo);
> 

True, thanks for pointing this out. Will fix this.

Regards,
Bharata.
