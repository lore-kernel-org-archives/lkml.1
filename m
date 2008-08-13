Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbYHMVgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbYHMVgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYHMVf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:35:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbYHMVfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:35:55 -0400
Date: Wed, 13 Aug 2008 17:35:29 -0400
From: Rik van Riel <riel@redhat.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Eric Paris" <eparis@redhat.com>,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, hch@infradead.org, andi@firstfloor.org,
       viro@ZenIV.linux.org.uk, arjan@infradead.org
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080813173529.7069b5f1@cuia.bos.redhat.com>
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
	<1218646065.3540.75.camel@localhost.localdomain>
	<20080813173722.13c9c306@lxorguk.ukuu.org.uk>
	<1218646833.3540.82.camel@localhost.localdomain>
	<20080813205906.559d3f37@lxorguk.ukuu.org.uk>
	<2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 17:24:28 -0400
"Press, Jonathan" <Jonathan.Press@ca.com> wrote:

> I may be missing something about your suggestion, but I don't see how
> this would work.  Who does the chmod?

Chmod is also not a solution to the hierarchical storage (or incremental
restore from backup) problem.

I believe we really do need the block-on-open.

-- 
All Rights Reversed
