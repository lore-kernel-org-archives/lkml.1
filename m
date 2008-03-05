Return-Path: <linux-kernel-owner+w=401wt.eu-S933888AbYCEBce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbYCEBce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbYCEBcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:32:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038AbYCEBcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:32:22 -0500
Date: Tue, 4 Mar 2008 17:30:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       alan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] pata: "I do not think it means, what you think it
 means."
Message-Id: <20080304173058.7679b7c8.akpm@linux-foundation.org>
In-Reply-To: <200803050234.40594.bzolnier@gmail.com>
References: <200803042316.m24NGI7k002489@imap1.linux-foundation.org>
	<200803050234.40594.bzolnier@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008 02:34:40 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Wednesday 05 March 2008, akpm@linux-foundation.org wrote:
> > From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > 
> > When masking mask out the modes that are unsupported not the ones that are
> > supported.  This makes life happier.
> > 
> 
> Jeff,
> 
> Could we get this merged ASAP (it was first posted on 26th February)?
> 
> This patch fixes data corruption for libata PATA ServerWorks and HPT drivers.
> 
> [ IDE users are already leaving happy life since they are not affected
>   (modes masking has always worked correctly in the original drivers)...
> 
>   Can we make life happy also for libata PATA users? :) ]
> 

(edited to undo top-posting damage)

I didn't know any of that.  The changelog might have been kinda fun, but
given that it failed to tell us that the patch fixes data-corruption
errors, the changelog was excrutiatingly bad.

Do we need this fix in 2.6.24.x as well?
