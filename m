Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbXJ2NkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbXJ2NkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXJ2Njx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:39:53 -0400
Received: from ppsw-8.csi.cam.ac.uk ([131.111.8.138]:45934 "EHLO
	ppsw-8.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbXJ2Njx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:39:53 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Mike Galbraith <efault@gmx.de>
In-Reply-To: <1193658311.7324.2.camel@Homer.simpson.net>
Subject: Re: [Linux-NTFS-Dev] 2.6.23 regression: second access of empty ntfs file leads to D	state hang
References: <1193638086.7409.21.camel@Homer.simpson.net> <E3E758D0-25AC-45B8-9BAB-F8CDF75AF3CA@cam.ac.uk> <1193658311.7324.2.camel@Homer.simpson.net>
Message-Id: <4E61D235-B8E8-43DF-96A5-B3169E6AB223@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v912)
Date: Mon, 29 Oct 2007 13:39:32 +0000
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ntfs-dev@lists.sourceforge.net
X-Mailer: Apple Mail (2.912)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Thanks for the files.  That is really odd.  And you are sure this just  
works with 2.6.22.10 on the exact same file?  Have you run  "chkdsk / 
f /v /x" on the NTFS volume from Windows?

Would you be able to apply the attached patch to your 2.6.23.1 kernel  
and try again and then send me the NTFS error messages?  The patch  
should cause more verbose error reporting to happen...  Thanks!

Best regards,

	Anton

On 29 Oct 2007, at 11:45, Mike Galbraith wrote:
> On Mon, 2007-10-29 at 10:31 +0000, Anton Altaparmakov wrote:
>
>> Could you post the complete dmesg output, please?
>
> Attached.  This is after a reboot though, but a fresh attempt to sum  
> the
> 0 length file, so the NTFS message is there.
>
>> Nothing related has changed in the NTFS driver between 2.6.22.10 and
>> 2.6.23 so I expect something else to be at fault here.
>>
>> Could you post your .config as well, please?
>
> Also attached.
>
> -Mike

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

