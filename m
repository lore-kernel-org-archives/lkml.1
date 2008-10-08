Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbYJHNBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbYJHNBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 09:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYJHNA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 09:00:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53210 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbYJHNA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 09:00:57 -0400
Date: Wed, 8 Oct 2008 09:00:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/4] integrity: special fs magic
Message-ID: <20081008130056.GC31684@infradead.org>
References: <cover.1223401603.git.zohar@linux.vnet.ibm.com> <87b9b5f88d5ed93a7985c14b413cf8d74ceea69c.1223401604.git.zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87b9b5f88d5ed93a7985c14b413cf8d74ceea69c.1223401604.git.zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 02:00:12PM -0400, Mimi Zohar wrote:
> Discussion on the mailing list questioned the use of these
> magic values in userspace, concluding these values are already
> exported to userspace via statfs and their correct/incorrect
> usage is left up to the userspace application.
> 
>   - Move special fs magic number definitions to magic.h
>   - Add magic.h include

This should be patch 1, and we can put in in ASAP even if the rest needs
some more work.

