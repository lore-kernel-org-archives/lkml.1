Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYHTKVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYHTKVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYHTKVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:21:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39474 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYHTKVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:21:31 -0400
Date: Wed, 20 Aug 2008 11:21:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, michael_e_brown@dell.com
Subject: Re: [PATCH 2/2] Add Dell laptop driver
Message-ID: <20080820102125.GA14278@srcf.ucam.org>
References: <20080816202452.GA3331@srcf.ucam.org> <20080816202640.GB3331@srcf.ucam.org> <20080816203027.GC3331@srcf.ucam.org> <20080819234637.c6075e16.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819234637.c6075e16.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 11:46:37PM -0700, Andrew Morton wrote:
> > +struct calling_interface_buffer {
> > +	u16 class;
> > +	u16 select;
> > +	volatile u32 input[4];
> > +	volatile u32 output[4];
> > +} __attribute__ ((packed));
> 
> checkpatch will direct you to a fine document.

The address of the structure is passed to the BIOS, and it's then 
modified in system management mode. I think volatile is the right thing 
here? I'll fix up the rest.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
