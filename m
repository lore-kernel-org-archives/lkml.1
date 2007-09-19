Return-Path: <linux-kernel-owner+w=401wt.eu-S1763158AbXISRwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763158AbXISRwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbXISRwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:52:21 -0400
Received: from ppsw-3.csi.cam.ac.uk ([131.111.8.133]:41355 "EHLO
	ppsw-3.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXISRwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:52:19 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <Pine.LNX.4.64.0709191028211.11138@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <20070919033641.009931707@sgi.com> <alpine.DEB.0.9999.0709182329110.6251@chino.kir.corp.google.com> <E1A595D3-FD5B-44EA-A99D-BB581642F0E8@cam.ac.uk> <Pine.LNX.4.64.0709191028211.11138@schroedinger.engr.sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4A1C0AC9-85CB-43C8-B824-80FD6FA91A2D@cam.ac.uk>
Cc: David Rientjes <rientjes@google.com>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [03/17] is_vmalloc_addr(): Check if an address is within the vmalloc boundaries
Date: Wed, 19 Sep 2007 18:52:08 +0100
To: Christoph Lameter <clameter@sgi.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Sep 2007, at 18:29, Christoph Lameter wrote:
> On Wed, 19 Sep 2007, Anton Altaparmakov wrote:
>> There even is such a function already in mm/ 
>> sparse.c::vaddr_in_vmalloc_area()
>> with pretty identical content.  I would suggest either this new  
>> inline should
>> go away completely and use the existing one and export it or the  
>> existing one
>> should go away and the inline should be used.  It seems silly to  
>> have two
>> functions with different names doing exactly the same thing!
>
> Just in case you have not noticed: This patchset removes the
> vaddr_in_vmalloc_area() in sparse.c

That's great!  And sorry I did not notice that bit...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


