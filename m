Return-Path: <linux-kernel-owner+w=401wt.eu-S1763658AbXISRxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763658AbXISRxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbXISRwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:52:55 -0400
Received: from ppsw-3.csi.cam.ac.uk ([131.111.8.133]:41555 "EHLO
	ppsw-3.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbXISRwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:52:54 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <Pine.LNX.4.64.0709191029230.11138@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <20070919033641.009931707@sgi.com> <alpine.DEB.0.9999.0709182329110.6251@chino.kir.corp.google.com> <E1A595D3-FD5B-44EA-A99D-BB581642F0E8@cam.ac.uk> <alpine.DEB.0.9999.0709190103560.12827@chino.kir.corp.google.com> <167F960F-0A93-4263-8AE6-1B0CEBB2C9D1@cam.ac.uk> <Pine.LNX.4.64.0709191029230.11138@schroedinger.engr.sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <39CAD720-C349-4C5C-819B-74BA327B0158@cam.ac.uk>
Cc: David Rientjes <rientjes@google.com>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [03/17] is_vmalloc_addr(): Check if an address is within the vmalloc boundaries
Date: Wed, 19 Sep 2007 18:52:46 +0100
To: Christoph Lameter <clameter@sgi.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Sep 2007, at 18:29, Christoph Lameter wrote:
> On Wed, 19 Sep 2007, Anton Altaparmakov wrote:
>> I suspect that is_vmalloc_addr() should not be in linux/mm.h at  
>> all and should
>> be in linux/vmalloc.h instead and vmalloc.h should include linux/ 
>> highmem.h.
>> That would be more sensible than sticking a vmalloc related  
>> function into
>> linux/mm.h where it does not belong...
>
> Tried it and that leads to all sort of other failures.

Ah, a new header file "vaddr.h" or something then?

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


