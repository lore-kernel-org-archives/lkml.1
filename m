Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXBTR44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXBTR44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932979AbXBTR44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:56:56 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:28682 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbXBTR44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:56:56 -0500
Date: Tue, 20 Feb 2007 12:54:57 -0500
From: Chris Mason <chris.mason@oracle.com>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Cc: Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
       Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Message-ID: <20070220175457.GS6133@think.oraclecorp.com>
References: <20070220170335.GR6133@think.oraclecorp.com> <B41635854730A14CA71C92B36EC22AAC871D9D@mssmsx411>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC871D9D@mssmsx411>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 08:17:51PM +0300, Ananiev, Leonid I wrote:
> aio-stress command lines used for test
> 1) mem=1G in kernel boot param if you have more
> 2) mk2fs for test_file
> 3) dd if=/dev/zero of=<test_file> bs=1M count=1200
> 4) aiostress -s 1200m -o 2 -i 1 -r 16k <test_file>
> 

Sorry, this aio-stress command line doesn't do O_DIRECT.  Do you have
this bundled into a test script that I can try?

-chris
