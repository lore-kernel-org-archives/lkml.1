Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbXCLVA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbXCLVA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXCLVA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:00:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60483
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbXCLVA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:00:27 -0400
Date: Mon, 12 Mar 2007 14:00:25 -0700 (PDT)
Message-Id: <20070312.140025.21595408.davem@davemloft.net>
To: Eric.Moore@lsi.com
Cc: Valdis.Kletnieks@vt.edu, rpjday@mindspring.com,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] MPT FUSION: Delete unused header files.
From: David Miller <davem@davemloft.net>
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70623ED6@NAMAIL4.ad.lsil.com>
References: <200703112232.l2BMWbAI010768@turing-police.cc.vt.edu>
	<664A4EBB07F29743873A87CF62C26D70623ED6@NAMAIL4.ad.lsil.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Moore, Eric" <Eric.Moore@lsi.com>
Date: Mon, 12 Mar 2007 10:19:18 -0600

> Valdis.Kletnieks silly little rant: 
> 
> > Certainly appropriate content for something on your website, 
> > and vendors who
> > provide programs like dmidecode and parsemce are always 
> > welcome. I could
> > probably be convinced that such info should have at least a 
> > pointer somewhere
> > in Documentation/lsi_debug.txt or some such.  But quite 
> > frankly, if I'm reduced
> > to wading through *.h files to figure out what some 
> > recalcitrant hardware is
> > upset about, there's been a failure in documentation.  
> > *ESPECIALLY* if I
> > go look at drivers/whatever/source.c and it doesn't even 
> > *reference* the *.h
> > file in question.
> 
> 
> Its apparent to me that you don't have our hardware, nor have you
> actually waded thru this driver source code. 
> 
> If you did, you would of noticed that the header you want to delete, is
> actually referenced in the *.c source code.   The file "mpi_log_fc.h",
> is indeed mentioned in mptbase.c, in the function called
> mpt_fc_log_info, in the documention section above the function.    This
> header file is very helpful to those supporting our hardware, and those
> using it
> For SAS(mpi_log_sas.h), I have broken out each loginfo in the strings
> you will find defined in originator_str, iop_code_str, pl_code_str, etc,
> I probably do that with fibre.
> 
> If its that important to you to have the header files included, I will
> provide a patch that does that.    

If you're going to include it just for the sake of including it, not
because the code in question actually uses types or function
declarations defined in there, don't bother, you're just using an
anti-social mechanism to keep this header file in the tree.

Please, let's kill this header file if it is unused.
