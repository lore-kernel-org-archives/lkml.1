Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbXF0R0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbXF0R0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758834AbXF0R0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:26:22 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:55064 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735AbXF0R0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:26:21 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <alpine.LFD.0.98.0706271001070.8675@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706271138220.18280@hermes-1.csi.cam.ac.uk> <alpine.LFD.0.98.0706271001070.8675@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3EDCA6F8-1597-4413-B496-55CF9361455B@cam.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ntfs-dev@lists.sourceforge.net, ldm@flatcap.org
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [2.6 PATCH] Fix LDM for new field in the VOL5 VBLK.
Date: Wed, 27 Jun 2007 18:26:12 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Jun 2007, at 18:03, Linus Torvalds wrote:
> On Wed, 27 Jun 2007, Anton Altaparmakov wrote:
>>
>> Please apply the below patch to the LDM driver.
>
> This looks fine, but last time I applied a LDM patch just before  
> release,
> there was some embarrassing compile problem with it.
>
> See commit 72dd9ca59944.
>
> Which just makes me go "hmm.." at this stage.

Up to you.  What Ash tested was dropping the ldm.c and ldm.h that I  
emailed him into his kernel tree and compiling and booting.  Once he  
confirmed that it works and is parsing his LDM drives correctly I on  
my machine did "git diff > file", then scp-ed the file to the mail  
server, created a message in pine, and did "ctrl+r file" to insert it  
into the message.  After I had sent the message to you I exported the  
message to a file in pine, deleted the message text and did a diff  
with the original patch and it showed no differences.

What you refer to when I did the diff after the fact the diff failed  
with a line difference...  The patch had gotten corrupted (probably  
by me)...

So I can only assume it will work this time.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


