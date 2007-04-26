Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbXDZNZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbXDZNZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXDZNZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:25:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38188 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754040AbXDZNZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:25:33 -0400
Date: Thu, 26 Apr 2007 14:28:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426142846.45ee23af@the-village.bc.nu>
In-Reply-To: <m1abwvofke.fsf@ebiederm.dsl.xmission.com>
References: <20070424222105.883597089@sgi.com>
	<m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com>
	<m1abwvofke.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Oh we have scores of these hacks around. Look at the dvd/cd layer. The 
> > point is to get rid of those.
> 
> Perhaps this is just a matter of cleaning them up so they are no
> longer hacks?

CD and DVD media support various non power-of-two block sizes. Supporting
more block sizes would also be useful as we could then read older smart
media (256byte/sector) without the SCSI layer objecting and the like.

