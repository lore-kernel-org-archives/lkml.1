Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbXHTA3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbXHTA3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXHTA3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:29:30 -0400
Received: from ppsw-2.csi.cam.ac.uk ([131.111.8.132]:41606 "EHLO
	ppsw-2.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbXHTA33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:29:29 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <200708191719.48340.david-b@pacbell.net>
References: <20070819225546.GV21089@ftp.linux.org.uk> <200708191719.48340.david-b@pacbell.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E83C36D0-B72E-4E70-BEF6-4AF54BAD2863@cam.ac.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [PATCH] ptrdiff_t is not uintptr_t, damnit
Date: Mon, 20 Aug 2007 01:29:21 +0100
To: David Brownell <david-b@pacbell.net>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 20 Aug 2007, at 01:19, David Brownell wrote:
> On Sunday 19 August 2007, Al Viro wrote:
>> is wrong; for one thing, it's a bad C (it's what uintptr_t is for;  
>> in general
>> we are not even promised that ptrdiff_t is large enough to hold a  
>> pointer,
>
> ISTR we don't *have* a uintptr_t on all architectures, or that would
> be the appropriate thing to use in these 32/64 bit ABI scenarios.
>
>
>> Use unsigned long or uintptr_t instead.
>
> I suspect you mean "unsigned long long"...

No he doesn't.  "unsigned long" is guaranteed to be large enough to  
hold a pointer (at least on Linux anyway).

On a 32-bit arch "unsigned long" is 32-bit and pointers are 32-bit.

On a 64-bit archi "unsigned long" is 64-bit and pointers are 64-bit.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


