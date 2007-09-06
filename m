Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXIFXIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXIFXIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 19:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932575AbXIFXIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 19:08:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43361 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932474AbXIFXIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 19:08:14 -0400
Date: Thu, 6 Sep 2007 16:04:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] Linux Kernel Markers - Architecture Independent
 Code
Message-Id: <20070906160429.629c9497.akpm@linux-foundation.org>
In-Reply-To: <20070906160001.cfe48d78.randy.dunlap@oracle.com>
References: <20070906200733.194442762@polymtl.ca>
	<20070906200825.893834634@polymtl.ca>
	<20070906160001.cfe48d78.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 6 Sep 2007 16:00:01 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 06 Sep 2007 16:07:34 -0400 Mathieu Desnoyers wrote:
> 
> > Changelog:
> > - markers_mutex now nests inside module_mutex rather than the opposite.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Reviewed-by: Christoph Hellwig <hch@infradead.org>
> > Reviewed-by: Rusty Russell <rusty@rustcorp.com.au>
> > Reviewed-by: "Frank Ch. Eigler" <fche@redhat.com>
> 
> Documentation/SubmittingPatches recognizes Signed-off-by: and
> Acked-by:.  Nothing about Reviewed-by.  Quote:
> 
>   Acked-by: is not as formal as Signed-off-by:.  It is a record that the acker
>   has at least reviewed the patch and has indicated acceptance.
> 
> Reviewed-by: carries no such connotation or indication IMO.
> Please use Acked-by if that's what these reviewers have done.

Yeah.  We will start introducing Reviewed-by: (I haven't yet quite worked
out how yet) but it will be a quite formal thing and it would be something
which the reviewer explicitly provided.  For now, let's please stick with
acked-by (if those individuals did indeed send an acked-by)
