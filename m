Return-Path: <linux-kernel-owner+w=401wt.eu-S1161179AbXCAXoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161179AbXCAXoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161180AbXCAXoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:44:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:51803 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161179AbXCAXoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:44:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pnSr5D/CyJgAOMEmGZ7bt7nrHPuZyIN3Eqk5vxYrZ5R5SshW7q9wraKvxRBMgoKZIwEq5mM1yt/dLo1ZAkvCnlk8iiwJm2nIwsryofb2hrDnPBL29kKm0nGsjZz4fjF5B49iHsuivuDphbCzuit8T8pMj0bX+h9AuFd28Rgyeu0=
Message-ID: <b00ca3bd0703011544n6a9eccc8gfa9e44964bd68e9d@mail.gmail.com>
Date: Fri, 2 Mar 2007 07:44:15 +0800
From: "Antonino Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Jaya Kumar" <jayakumar.lkml@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Linux-fbdev-devel] [PATCH/RFC 2.6.20 1/2] fbdev, mm: Deferred IO support
In-Reply-To: <20070301140131.GA6603@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070225051312.17454.80741.sendpatchset@localhost>
	 <20070301140131.GA6603@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Sun, Feb 25, 2007 at 06:13:12AM +0100, Jaya Kumar wrote:
> > This patch implements deferred IO support in fbdev. Deferred IO is a way to
> > delay and repurpose IO. This implementation is done using mm's page_mkwrite
> > and page_mkclean hooks in order to detect, delay and then rewrite IO. This
> > functionality is used by hecubafb.
> >
> Any updates on this? If there are no other concerns, it would be nice to
> at least get this in to -mm for testing if nothing else.

The driver is already in the -mm tree.

>
> Jaya, can you roll the fsync() patch in to your defio patch? There's not
> much point in keeping them separate.

The fsync() patch was not included by Jaya, I believe.

Tony
