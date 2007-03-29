Return-Path: <linux-kernel-owner+w=401wt.eu-S1030634AbXC2SR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030634AbXC2SR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 14:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030632AbXC2SR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 14:17:56 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:55342 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030628AbXC2SRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 14:17:54 -0400
Date: Thu, 29 Mar 2007 20:05:24 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Subject: Re: Interface for the new fallocate() system call
In-Reply-To: <Pine.LNX.4.61.0703291314330.4366@chaos.analogic.com>
Message-ID: <Pine.LNX.4.61.0703292002210.31834@yvahk01.tjqt.qr>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
 <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
 <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
 <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com>
 <20070329115126.GB7374@amitarora.in.ibm.com> <Pine.LNX.4.61.0703291854000.31834@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0703291314330.4366@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
On Mar 29 2007 13:18, linux-os (Dick Johnson) wrote:
>
>I think it's always better to put only a pointer on the stack as
>above.

I have to disagree, since wrapping it into a struct and copying the struct
in kernelspace from userspace requires more code. Pointers only become
useful at 3 (rarely) or 4 (yeah, more likely) and 5+ (definitely)
arguments, (3) see above about copying, (4) middle thing and (5) tons of
arguments like mmap() should be wrapped up... for simplicity of dealing
with it later.


Jan
-- 
