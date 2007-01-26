Return-Path: <linux-kernel-owner+w=401wt.eu-S965092AbXAZLtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092AbXAZLtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965158AbXAZLtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:49:10 -0500
Received: from smtp.aaisp.net.uk ([81.187.81.51]:44312 "EHLO smtp.aaisp.net.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965092AbXAZLtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:49:09 -0500
X-Greylist: delayed 2147 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 06:49:09 EST
Date: Fri, 26 Jan 2007 11:13:09 +0000
From: Andrew Clayton <andrew@digital-domain.net>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gd@spherenet.de, petero2@telia.com, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, Uwe Bugla <uwe.bugla@gmx.de>,
       alan@lxorguk.ukuu.org.uk, Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, ttb@tentacle.dhs.org,
       rml@novell.com, Livio Soares <livio@eecg.toronto.edu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Malte =?UTF-8?B?U2NocsO2ZGVy?= <MalteSch@gmx.de>,
       "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-dev@namesys.com,
       Sami Farin <7atbggg02@sneakemail.com>, David Chinner <dgc@sgi.com>,
       xfs-masters@oss.sgi.com,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       takada <takada@mbf.nifty.com>, Jordan Crouse <jordan.crouse@amd.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: 2.6.20-rc5: known unfixed regressions (v3) (part 2)
Message-ID: <20070126111309.1732d727@zeus.pccl.info>
In-Reply-To: <20070124154725.GK17836@stusta.de>
References: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org>
	<20070124154725.GK17836@stusta.de>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007 16:47:25 +0100, Adrian Bunk wrote:

> 
> 
> Subject    : NFS triggers WARN_ON() in invalidate_inode_pages2_range()
> References : http://bugzilla.kernel.org/show_bug.cgi?id=7826
> Submitter  : Andrew Clayton <andrew@digital-domain.net>
> Caused-By  : Andrew Morton <akpm@osdl.org>
>              commit 8258d4a574d3a8c01f0ef68aa26b969398a0e140
> Handled-By : Trond Myklebust <trond.myklebust@fys.uio.no>
> Status     : Trond: the WARN_ON() needs to be thrown out
> 

Still present in -rc6

