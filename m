Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbXISNXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbXISNXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 09:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbXISNXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 09:23:38 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:40880 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbXISNXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 09:23:37 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <alpine.DEB.0.9999.0709190217530.17127@chino.kir.corp.google.com>
References: <20070919033605.785839297@sgi.com> <20070919033641.009931707@sgi.com> <alpine.DEB.0.9999.0709182329110.6251@chino.kir.corp.google.com> <E1A595D3-FD5B-44EA-A99D-BB581642F0E8@cam.ac.uk> <alpine.DEB.0.9999.0709190103560.12827@chino.kir.corp.google.com> <167F960F-0A93-4263-8AE6-1B0CEBB2C9D1@cam.ac.uk> <alpine.DEB.0.9999.0709190217530.17127@chino.kir.corp.google.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <918AEB61-0E65-41AD-A1D7-0226CFC40701@cam.ac.uk>
Cc: Christoph Lameter <clameter@sgi.com>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [03/17] is_vmalloc_addr(): Check if an address is within the vmalloc boundaries
Date: Wed, 19 Sep 2007 14:23:27 +0100
To: David Rientjes <rientjes@google.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Sep 2007, at 10:19, David Rientjes wrote:
> On Wed, 19 Sep 2007, Anton Altaparmakov wrote:
>> Although it may cause a problem as highmem.h also includes mm.h so  
>> a bit of
>> trickery may be needed to get it to compile...
>>
>> I suspect that is_vmalloc_addr() should not be in linux/mm.h at  
>> all and should
>> be in linux/vmalloc.h instead and vmalloc.h should include linux/ 
>> highmem.h.
>> That would be more sensible than sticking a vmalloc related  
>> function into
>> linux/mm.h where it does not belong...
>
> That is why I suggested include/linux/vmalloc.h as its home in the  
> first
> place.  And no, adding an include for linux/highmem.h (and asm/ 
> pgtable.h)
> to linux/vmalloc.h does not work.

I am sure Christoph can figure out somewhere that it will work.   
After all, the code in that function already exists both as another  
function and open coded in several places and compiles fine there...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


