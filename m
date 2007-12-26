Return-Path: <linux-kernel-owner+w=401wt.eu-S1751612AbXLZNCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbXLZNCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 08:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbXLZNC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 08:02:28 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3799 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbXLZNC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 08:02:27 -0500
Date: Wed, 26 Dec 2007 13:02:58 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch false ERROR: trailing statements should be on next line
Message-ID: <20071226130258.GC8346@shadowen.org>
References: <200712252150.lBPLo4wG031988@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712252150.lBPLo4wG031988@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2007 at 04:50:04PM -0500, Erez Zadok wrote:
> Using v2.6.24-rc6-125-g5356f66, code such as this:
> 
> 	if (is_file)	/* dirs can be unlinked but chdir'ed to */
> 		err = -ESTALE;
> 
> produces this false checkpatch error:
> 
> 	foo.c:947: ERROR: trailing statements should be on next line
> 
> I think comments such as the above should be allowed (plus a comment isn't a
> statement).  It's often very useful to put them right on the affected line.

Agreed.  checkpatch 0.13 already ignores these as statements.  A
positive side effect of other changes in this area.

Thanks for the report.

-apw
