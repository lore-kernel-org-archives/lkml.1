Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbXFWEE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbXFWEE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 00:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbXFWEEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 00:04:49 -0400
Received: from ozlabs.org ([203.10.76.45]:55498 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbXFWEEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 00:04:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18044.39897.718750.969247@cargo.ozlabs.ibm.com>
Date: Sat, 23 Jun 2007 14:04:41 +1000
From: Paul Mackerras <paulus@samba.org>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.06
In-Reply-To: <1182535330.26162.50.camel@localhost>
References: <e12915ec7c0cfcb5d6a7c4432f458161@pinky>
	<1182532151.26162.45.camel@localhost>
	<467C0CE9.5010502@austin.ibm.com>
	<1182535330.26162.50.camel@localhost>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen writes:

> Several of our on-disk filesystems have an ioctl function that already
> has indented goto labels.  I don't think it's quite worth churning all
> of these (working) filesystems to make a style checker happy.

I agree.

> I think it's worse style to be mixing label indentation in a file as it
> is to create new "correct" indentation labels.  That's why I suggested
> using context in the file to determine it rather than absolute rules.

I don't think indentation of labels is something one can or should be
too prescriptive about.  As you say, it depends on the context.

Having a script being fascist about such things makes it useless,
because I for one will just start ignoring the script totally.

Paul.
