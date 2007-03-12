Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXCLQTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXCLQTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXCLQTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:19:31 -0400
Received: from mail0.lsil.com ([147.145.40.20]:46852 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030572AbXCLQTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:19:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] MPT FUSION: Delete unused header files.
Date: Mon, 12 Mar 2007 10:19:18 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70623ED6@NAMAIL4.ad.lsil.com>
In-Reply-To: <200703112232.l2BMWbAI010768@turing-police.cc.vt.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] MPT FUSION: Delete unused header files.
Thread-Index: AcdkLS3u5lIcBYYNTpSQdHs11PdSKAAkfqNw
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: <Valdis.Kletnieks@vt.edu>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>
X-OriginalArrivalTime: 12 Mar 2007 16:19:19.0584 (UTC) FILETIME=[300B7A00:01C764C2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks silly little rant: 

> Certainly appropriate content for something on your website, 
> and vendors who
> provide programs like dmidecode and parsemce are always 
> welcome. I could
> probably be convinced that such info should have at least a 
> pointer somewhere
> in Documentation/lsi_debug.txt or some such.  But quite 
> frankly, if I'm reduced
> to wading through *.h files to figure out what some 
> recalcitrant hardware is
> upset about, there's been a failure in documentation.  
> *ESPECIALLY* if I
> go look at drivers/whatever/source.c and it doesn't even 
> *reference* the *.h
> file in question.


Its apparent to me that you don't have our hardware, nor have you
actually waded thru this driver source code. 

If you did, you would of noticed that the header you want to delete, is
actually referenced in the *.c source code.   The file "mpi_log_fc.h",
is indeed mentioned in mptbase.c, in the function called
mpt_fc_log_info, in the documention section above the function.    This
header file is very helpful to those supporting our hardware, and those
using it
For SAS(mpi_log_sas.h), I have broken out each loginfo in the strings
you will find defined in originator_str, iop_code_str, pl_code_str, etc,
I probably do that with fibre.

If its that important to you to have the header files included, I will
provide a patch that does that.    

Eric Moore
