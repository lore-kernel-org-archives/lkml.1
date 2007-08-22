Return-Path: <linux-kernel-owner+w=401wt.eu-S1764361AbXHVTE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764361AbXHVTE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbXHVTES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:04:18 -0400
Received: from mail.suse.de ([195.135.220.2]:38931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbXHVTER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:04:17 -0400
Date: Wed, 22 Aug 2007 21:58:08 +0200
From: Andi Kleen <ak@suse.de>
To: travis@sgi.com
Cc: Andi Kleen <ak@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 4/6] x86: Convert cpu_llc_id to be a per cpu variable
Message-ID: <20070822195808.GG8058@bingen.suse.de>
References: <20070822172101.138513000@sgi.com> <20070822172123.935063000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822172123.935063000@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 10:21:05AM -0700, travis@sgi.com wrote:
> Note the addtional change of the cpu_llc_id type from u8
> to int for ARCH x86_64 to correspond with ARCH i386.

At least currently it cannot be more than 8 bit. So why
waste memory? It would be better to change i386

-Andi
