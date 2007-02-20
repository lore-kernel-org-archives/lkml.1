Return-Path: <linux-kernel-owner+w=401wt.eu-S1030308AbXBTRG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308AbXBTRG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030307AbXBTRG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:06:28 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:56132 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030308AbXBTRG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:06:26 -0500
Date: Tue, 20 Feb 2007 12:03:35 -0500
From: Chris Mason <chris.mason@oracle.com>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Cc: Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
       Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Message-ID: <20070220170335.GR6133@think.oraclecorp.com>
References: <20070219213835.4032.87439.sendpatchset@tetsuo.zabbo.net> <B41635854730A14CA71C92B36EC22AAC871D92@mssmsx411>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC871D92@mssmsx411>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 07:57:49PM +0300, Ananiev, Leonid I wrote:
> Zach> This addresses an oops reported by Leonid Ananiev
> <leonid.i.ananiev@intel.com>
> Zach> as archived at http://lkml.org/lkml/2007/2/8/337.
> ....
> Zach> This was tested by running O_DIRECT aio-stress concurrently with
> buffered reads
> 
> The oops was with aio-stress only running in the loop
> WITHOUT buffered or mmaped IO which are patched and discussed now.
> Actually 47% aio is finished with EIO after patch.

I looked through the thread and couldn't find the aio-stress command
line used for the whole test.  Could you please post it here?

If aio+dio is being used to extend the file, you'll get pages in the
page cache, which is hopefully why you're able to trigger the EIOs.

-chris
