Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbYHPXXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbYHPXXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 19:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYHPXXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 19:23:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54668 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYHPXXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:23:41 -0400
Date: Sun, 17 Aug 2008 00:23:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Add Dell laptop driver
Message-ID: <20080816232336.GA6992@srcf.ucam.org>
References: <82e4877d0808161617k5404f4ectf6d502de5b7fea4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0808161617k5404f4ectf6d502de5b7fea4c@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 07:17:05PM -0400, Parag Warudkar wrote:
> > +	da_tokens = krealloc(da_tokens, (da_num_tokens + tokens) *
> > +			     sizeof(struct calling_interface_token),
> > +			     GFP_KERNEL);
> 
> Isn't a NULL check required here?

To the extent that it would result in this failing gracefully before 
some other part of the kernel becomes hideously upset, sure. I have a 
hard time caring, but I can easily fix it if other people do :)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
