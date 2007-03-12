Return-Path: <linux-kernel-owner+w=401wt.eu-S965398AbXCLN3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398AbXCLN3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXCLN3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:29:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47337 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965398AbXCLN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:29:22 -0400
Date: Mon, 12 Mar 2007 15:29:20 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Jan Kara <jack@suse.cz>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
Subject: Re: [PATCH 1/7] revoke: special mmap handling
In-Reply-To: <20070312132553.GG30777@atrey.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.64.0703121527140.20780@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703091012530.32320@sbz-30.cs.Helsinki.FI>
 <20070312132553.GG30777@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Honza,

On Mon, 12 Mar 2007, Jan Kara wrote:
> > +#define VM_REVOKED	0x04000000	/* Mapping has been revoked */
> > +
>   Is it intended to conflict with VM_ALWAYSDUMP? I'd guess not and if
> yes, it definitely deserves a comment...

Peter Zijlstra spotted this also and it has been fixed in the patches I 
sent to Andrew yesterday.

			Pekka
