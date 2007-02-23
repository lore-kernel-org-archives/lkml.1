Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbXBWSNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbXBWSNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933158AbXBWSNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:13:08 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52380 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152AbXBWSNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:13:06 -0500
In-Reply-To: <20070220165824.GA31315@sergelap.austin.ibm.com>
To: serue@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>,
       kjhall@linux.vnet.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       David Safford <safford@watson.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] slim: move file revocation into file_table.c and mprotect.c
X-Mailer: Lotus Notes Release 7.0.1P Oct 16, 2006
Message-ID: <OF8F16AF17.D3D928C1-ON8525728B.004D777E-8525728B.006512C6@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Fri, 23 Feb 2007 13:13:06 -0500
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V80_M3_10312006|October 31, 2006) at
 02/23/2007 13:13:06,
	Serialize complete at 02/23/2007 13:13:06
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

serue@linux.vnet.ibm.com wrote on 02/20/2007 11:58:24 AM:

> Here is a attempt at resolving some of the complaints against the
> slim security module.  The file revocation is perceived as too 
> intrusive to live in a security module itself, so it is moved into
> file_table.c.
> 
> This patch retains the explicit file->f_mode tweaking to revoke
> FMODE_WRITE.  That can be removed by using an approach like Pekka's
> revokefs, using files in the revokefs filesystem with ->read() passed
> through to the original file, but ->write() intercepted.
> 
> Comments greatly appreciated.

I've tested the patch with slim.  The patch has been up and running
on my system for a couple of weeks now, and it seems to be working 
just fine.  Is the approach acceptable?  On the assumption that it 
is, how should we go forward with it?  Can it get a test run in -mm?
If not, what would be a more acceptable approach?

Thanks!

Mimi Zohar
