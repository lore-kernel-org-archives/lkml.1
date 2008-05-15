Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYEODzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYEODzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYEODzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:55:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38806 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbYEODzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:55:40 -0400
Date: Wed, 14 May 2008 20:55:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Lang <Michael.Lang@jackal-net.at>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Kernel Panic when accessing NFS share and locking files
Message-ID: <20080514205528.3bf3955d@infradead.org>
In-Reply-To: <20080514204932.13243cab.akpm@linux-foundation.org>
References: <482B2108.4090902@jackal-net.at>
	<20080514204932.13243cab.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 20:49:32 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 14 May 2008 19:27:36 +0200 Michael Lang
> <Michael.Lang@jackal-net.at> wrote:
> 
> > Hi,
> > 
> > we encountered a serious problem, when using Solaris NFS (Server) 
> > accessing it with a CentOS5.1/RHEL5.1 client.



> Which kernel version is being used?

that'll be a 2.6.18 variant ;)

there have been some, but not too many, reports of a trace like this:
http://www.kerneloops.org/search.php?search=__fput

