Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0CHJjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:39:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab0CHJjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:39:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100303030308.GA29025@linux-sh.org>
References: <20100303030308.GA29025@linux-sh.org> <1267554584-24349-1-git-send-email-steve@digidescorp.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dhowells@redhat.com, "Steven J. Magnani" <steve@digidescorp.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: get_user_pages(): pin last page on non-page-aligned start
Date: Mon, 08 Mar 2010 09:38:28 +0000
Message-ID: <16242.1268041108@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt <lethal@linux-sh.org> wrote:

> > The noMMU version of get_user_pages() fails to pin the last page
> > when the start address isn't page-aligned. The patch fixes this in a way
> > that makes find_extend_vma() congruent to its MMU cousin.
> > 
> > Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> 
> Looks good to me.  David?

I don't seem to have the original patch.

David
