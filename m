Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbZFHNxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbZFHNxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZFHNxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:53:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53730 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbZFHNxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:53:33 -0400
Subject: Re: [PATCH] Add a gfp-translate script to help understand page
 allocation failure reports
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <4A2D15DD.1030005@redhat.com>
References: <20090608132950.GB15070@csn.ul.ie> <4A2D15DD.1030005@redhat.com>
Date: Mon, 08 Jun 2009 16:53:33 +0300
Message-Id: <1244469213.6315.6.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 09:45 -0400, Rik van Riel wrote:
> Mel Gorman wrote:
> 
> >   mel@machina:~/linux-2.6 $ scripts/gfp-translate 0x4020
> >   Source: /home/mel/linux-2.6
> >   Parsing: 0x4020
> >   #define __GFP_HIGH	(0x20)	/* Should access emergency pools? */
> >   #define __GFP_COMP	(0x4000) /* Add compound page metadata */
> > 
> > The script is not a work of art but it has come in handy for me a few times
> > so I thought I would share.
> 
> Sweet.  This is just what I've been waiting for!
> 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

