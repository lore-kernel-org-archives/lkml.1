Return-Path: <linux-kernel-owner+w=401wt.eu-S932630AbXF2ACy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbXF2ACy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 20:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763876AbXF2ACr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 20:02:47 -0400
Received: from mail.app.aconex.com ([203.89.192.138]:55355 "EHLO
	postoffice.aconex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760948AbXF2ACr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 20:02:47 -0400
X-Greylist: delayed 1324 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jun 2007 20:02:46 EDT
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com
In-Reply-To: <20070628181913.GC1674@amitarora.in.ibm.com>
References: <20070614091458.GH5181@schatzie.adilger.int>
	 <20070614120413.GD86004887@sgi.com>
	 <20070614193347.GN5181@schatzie.adilger.int>
	 <20070625132810.GA1951@amitarora.in.ibm.com>
	 <20070625134500.GE1951@amitarora.in.ibm.com>
	 <20070625150320.GA8686@amitarora.in.ibm.com>
	 <20070625214626.GJ5181@schatzie.adilger.int>
	 <20070626103247.GA19870@amitarora.in.ibm.com>
	 <20070626153413.GC6652@schatzie.adilger.int>
	 <20070626231803.GQ31489@sgi.com>
	 <20070628181913.GC1674@amitarora.in.ibm.com>
Content-Type: text/plain
Organization: Aconex
Date: Fri, 29 Jun 2007 09:39:40 +1000
Message-Id: <1183073980.15488.134.camel@edge.yarra.acx>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 23:49 +0530, Amit K. Arora wrote:
> 
> > Correct, but for swap files that's not an issue - no user should be
> able
> > too read them, and FA_MKSWAP would really need root privileges to
> execute.
> 
> Will the FA_MKSWAP mode still be required with your suggested change
> of
> teaching do_mpage_readpage() about unwritten extents being in place ?
> Or, will you still like to have FA_MKSWAP mode ? 

There's no need for a MKSWAP flag.

cheers.

--
Nathan

