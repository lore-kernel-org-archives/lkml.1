Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYHMVld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYHMVld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYHMVlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:41:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37376 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752590AbYHMVlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:41:21 -0400
Date: Wed, 13 Aug 2008 22:23:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rik van Riel <riel@redhat.com>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>,
       "Eric Paris" <eparis@redhat.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk,
       arjan@infradead.org
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080813222353.5c809060@lxorguk.ukuu.org.uk>
In-Reply-To: <20080813173529.7069b5f1@cuia.bos.redhat.com>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
	<1218646065.3540.75.camel@localhost.localdomain>
	<20080813173722.13c9c306@lxorguk.ukuu.org.uk>
	<1218646833.3540.82.camel@localhost.localdomain>
	<20080813205906.559d3f37@lxorguk.ukuu.org.uk>
	<2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
	<20080813173529.7069b5f1@cuia.bos.redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 17:35:29 -0400
Rik van Riel <riel@redhat.com> wrote:

> On Wed, 13 Aug 2008 17:24:28 -0400
> "Press, Jonathan" <Jonathan.Press@ca.com> wrote:
> 
> > I may be missing something about your suggestion, but I don't see how
> > this would work.  Who does the chmod?
> 
> Chmod is also not a solution to the hierarchical storage (or incremental
> restore from backup) problem.
> 
> I believe we really do need the block-on-open.

The block on open is orthogonal really. Useful for HSM, useful for
certain very primitive scanning but not much else that I can see.

And its a minor mod to the security hooks to allow it as far as I can see
