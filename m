Return-Path: <linux-kernel-owner+w=401wt.eu-S1763144AbXK2RE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763144AbXK2RE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760708AbXK2REP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:04:15 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:35083 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760121AbXK2REP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:04:15 -0500
Date: Thu, 29 Nov 2007 10:04:13 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Anders Henke <anders.henke@1und1.de>
Cc: FUJITA Tomonori <tomof@acm.org>, jack@ucw.cz,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in directory) (fwd)
Message-ID: <20071129170413.GC2584@parisc-linux.org>
References: <20071129130319.GA2642@atrey.karlin.mff.cuni.cz> <20071129235813Y.tomof@acm.org> <20071129164557.GD30957@1und1.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129164557.GD30957@1und1.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 05:45:57PM +0100, Anders Henke wrote:
> On Nov 29 2007, FUJITA Tomonori wrote:
> > @@ -3295,7 +3295,7 @@ static struct scsi_host_template adpt_template = {
> >  	.this_id		= 7,
> >  	.cmd_per_lun		= 1,
> >  	.use_clustering		= ENABLE_CLUSTERING,
> > -	.use_sg_chaining	= ENABLE_SG_CHAINING,
> > +	.use_sg_chaining	= DISABLE_SG_CHAINING,
> >  };
> >  
> >  static s32 adpt_scsi_register(adpt_hba* pHba)
> 
> The structure to patch does look different and doesn't include an
> tag "use_sg_chaining":
> 
>         .this_id                = 7,
>         .cmd_per_lun            = 1,
>         .use_clustering         = ENABLE_CLUSTERING,

Just add the line
	.use_sg_chaining	= DISABLE_SG_CHAINING,

> };

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
