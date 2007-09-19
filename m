Return-Path: <linux-kernel-owner+w=401wt.eu-S1751364AbXISApV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbXISApV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 20:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbXISApJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 20:45:09 -0400
Received: from hera.cwi.nl ([192.16.191.8]:47107 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbXISApH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 20:45:07 -0400
Date: Wed, 19 Sep 2007 02:46:58 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Satyam Sharma <satyam@infradead.org>
Cc: Jan Kara <jack@suse.cz>, "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iso9660 vs udf
Message-ID: <20070919004657.GB11444@mette>
References: <20070915214926.GA31416@mette> <20070918144734.GB13304@atrey.karlin.mff.cuni.cz> <alpine.LFD.0.999.0709190534490.26241@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709190534490.26241@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 05:48:28AM +0530, Satyam Sharma wrote:

> > > On the other hand, this filesystem announces itself as UDF
> > > ("CD-RTOS" "CD-BRIDGE" "CDUDF File System - Adaptec Inc"),
> > > perhaps the kernel code should be more robust.
> 
> Could you send the complete dmesg log, and what you mean with filesystem/
> kernel (incorrectly?) announcing it as UDF here ... I agree with Jan,
> this sounds like an issue with mount(8) to me.

You already got the relevant part of the dmesg log. Slightly more below.

I think the filesystem can be treated both as iso9660 and as udf,
at least that is what I seem to recall CD-BRIDGE means.  Thus,
if the kernel cannot mount it as udf, I think it is a kernel flaw.
Given that kernel flaw, and the fact that mounting as iso9660 works,
mount(8) could work around the kernel problem by guessing iso9660.
But maybe we should first try to fix the kernel.

Andries

Failed mount:
UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'Wisk1956-82', timestamp 2006/03/07 16:26 (1078)
udf: udf_read_inode(ino 547) failed !bh
UDF-fs: Error in udf_iget, block=1, partition=1

Success:
ISO 9660 Extensions: Microsoft Joliet Level 3
ISOFS: changing to secondary root

