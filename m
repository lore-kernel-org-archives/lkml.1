Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYLSFtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYLSFtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYLSFtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:49:09 -0500
Received: from kroah.org ([198.145.64.141]:43104 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751149AbYLSFtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:49:08 -0500
Date: Thu, 18 Dec 2008 21:14:36 -0800
From: Greg KH <greg@kroah.com>
To: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: device driver probe return codes
Message-ID: <20081219051436.GA29543@kroah.com>
References: <20081216215331.GH12431@fluff.org.uk> <20081216234128.05a343bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216234128.05a343bb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 11:41:28PM -0800, Andrew Morton wrote:
> On Tue, 16 Dec 2008 21:53:31 +0000 Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > I would like some feedback on the following regarding some
> > form of standardising return codes from a device driver probe
> > to try and stop some basic mistakes.
> > 
> > This document is not complete, any additions would be welcone.

Hm, shouldn't you have at least copied me on this?

What is this for?  Each of the different busses treat return codes for
their probe functions a bit differently, are you wanting to unify them?
And if so, why?

thanks,

greg k-h
