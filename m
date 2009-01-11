Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbZAKHwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbZAKHwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZAKHwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:52:30 -0500
Received: from 8bytes.org ([88.198.83.132]:41419 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZAKHw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:52:29 -0500
Date: Sun, 11 Jan 2009 08:52:27 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com
Subject: Re: [PATCH 07/16] dma-debug: add debugfs interface
Message-ID: <20090111075227.GG9466@8bytes.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-8-git-send-email-joerg.roedel@amd.com> <20090110230826.GJ17917@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110230826.GJ17917@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 12:08:26AM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +/* Global error count */
> > +static u32 error_count;
> > +
> > +/* Global error show enable*/
> > +static u32 show_all_errors __read_mostly;
> > +/* Number of errors to show */
> > +static u32 show_num_errors = 1;
> > +
> >  static u32 num_free_entries;
> >  static u32 min_free_entries;
> 
> Small detail: please use native C types for non-hardware variables - 
> 'unsigned int', 'unsigned long', etc.
> 
> u32/u64 is typically used for variables where there is a real significance 
> to the precise width of the variable: there's either a hardware or a 
> user-space ABI involved.

Hmm, these variables are exported to debugfs. Thats the reason I made
them u32.

Joerg
