Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbYEEXew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbYEEXew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYEEXeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:34:44 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:50573 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbYEEXen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:34:43 -0400
X-ClientAddr: 220.233.82.121
Subject: RE: [PATCH 07/56] microblaze_v2: Signal support
From: John Williams <john.williams@petalogix.com>
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, John Linn <linnj@xilinx.com>,
       matthew@wil.cx, will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <20080505213244.8DC757A0084@mail70-wa4.bigfish.com>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
	 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
	 <20080505213244.8DC757A0084@mail70-wa4.bigfish.com>
Content-Type: text/plain
Organization: PetaLogix
Date: Tue, 06 May 2008 09:33:56 +1000
Message-Id: <1210030436.5798.148.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-05 at 14:32 -0700, Stephen Neuendorffer wrote:
> (multiple places)  can this code (and flush_cache_sigtramp()) go away?
> 
> +#if 0
> +		flush_cache_sigtramp((unsigned long)frame->tramp);
> +#endif

You have to icache_invalidate the sigtramp because you are writing into
memory that will shortly be executed. 

I'm not sure why this is #if'd away in the first place?

John


