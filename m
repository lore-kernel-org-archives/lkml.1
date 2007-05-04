Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbXEDOu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbXEDOu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbXEDOu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:50:26 -0400
Received: from ppsw-9.csi.cam.ac.uk ([131.111.8.139]:57782 "EHLO
	ppsw-9.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbXEDOuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:50:25 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <20070504094610.GA31607@infradead.org>
References: <E1HjjyF-00022D-00@calista.eckenfels.net> <0733FB88-3E6E-47B7-A55D-704B5C0DB239@cam.ac.uk> <20070504094610.GA31607@infradead.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <784B7DF1-6633-4356-80F2-A93A5A148F6A@cam.ac.uk>
Cc: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: Ext3 vs NTFS performance
Date: Fri, 4 May 2007 15:47:33 +0100
To: Christoph Hellwig <hch@infradead.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 May 2007, at 10:46, Christoph Hellwig wrote:

> On Fri, May 04, 2007 at 09:12:31AM +0100, Anton Altaparmakov wrote:
>> Nothing to do with win32 functions.  Windows does NOT create sparse
>> files therefore it never can have an issue like ext3 does in this
>> scenario.  Windows will cause nice allocations to happen because of
>> this and the 1-byte writes are perfectly sensible in this regard.
>> (Although a little odd as Windows has a proper API for doing
>> preallocation so I don't get why it is not using that instead...)
>
> Which means the right place to fix this is samba.

Absolutely, agreed.

> Samba just need
> to intersept lseek and pread/pwrite to never allocate sparse files
> but do the right thing instead.  Now what the right thing would  
> probably
> be a preallocate instead of writing zeroes, and we need to provide the
> infrastructure for them to do it, which is in progress currently.
> (And in fact samba already does the right thing for XFS if you use
> the prealloc samba vfs module, which AFAIK is not the default)

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


